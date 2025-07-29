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

            return GestureDetector(
              onTap: () async {
                inputCont.form?.unfocus();
                await _pickFile(control);
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 4,
                      left: 8,
                      right: 4,
                      bottom: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Get.theme.primaryColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "${field.label}".ctr + " ${field.required ? '*' : ''}",
                                style: Get.theme.inputDecorationTheme.labelStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      displayText,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(
                                    Icons.attach_file,
                                    color: hasError
                                        ? Get.theme.colorScheme.error
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (hasError)
                          Text(
                            (errorText ?? "").ctr,
                            style: TextStyle(color: Get.theme.colorScheme.error),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
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