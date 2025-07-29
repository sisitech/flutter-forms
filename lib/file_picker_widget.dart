library flutter_form;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form/input_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FilePickerWidget extends ReactiveFormField<String, String> {
  final FormItemField field;

  FilePickerWidget({
    super.key,
    required super.formControlName,
    required this.field,
  }) : super(
          builder: (ReactiveFormFieldState<String, String> fieldState) {
            final inputCont = Get.find<InputController>(tag: field.name);
            final control = fieldState.control;

            String? errorText;
            if (control.errors.isNotEmpty) {
              errorText = control.errors.keys.join("\n");
            }
            bool hasError = (errorText?.isNotEmpty ?? false) && control.touched;

            String displayText = control.value?.isNotEmpty == true
                ? control.value!.split('/').last
                : "Select File".ctr;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label above input area (like other form inputs)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "${field.label}".ctr + " ${field.required ? '*' : ''}",
                    style: Get.theme.inputDecorationTheme.labelStyle,
                  ),
                ),
                const SizedBox(height: 8),
                
                // File picker input area
                GestureDetector(
                  onTap: () async {
                    inputCont.form?.unfocus();
                    await _pickFile(control);
                  },
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 48), // Match standard input height
                    padding: const EdgeInsets.all(12), // More generous padding like other inputs
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hasError ? Get.theme.colorScheme.error : Get.theme.primaryColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            displayText,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: control.value?.isNotEmpty == true 
                                ? null 
                                : Get.theme.hintColor,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.attach_file,
                          color: hasError
                              ? Get.theme.colorScheme.error
                              : Get.theme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Error message below input
                if (hasError) ...[
                  const SizedBox(height: 8),
                  Text(
                    (errorText ?? "").ctr,
                    style: TextStyle(color: Get.theme.colorScheme.error),
                  ),
                ],
                
                const SizedBox(height: 30), // Match standard form input spacing
              ],
            );
          },
        );

  static Future<void> _pickFile(FormControl<String> control) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        control.updateValue(result.files.single.path!);
        control.focus();
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }
}