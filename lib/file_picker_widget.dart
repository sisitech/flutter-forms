library flutter_form;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FilePickerWidget extends ReactiveFormField<String, String> {
  final FormItemField field;

  FilePickerWidget({
    super.key,
    required super.formControlName,
    required this.field,
  }) : super(
          builder: (ReactiveFormFieldState<String, String> fieldState) {
            final control = fieldState.control;
            final context = fieldState.context;
            final theme = Theme.of(context);

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
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "${field.label}".ctr + " ${field.required ? '*' : ''}",
                    style: theme.inputDecorationTheme.labelStyle,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    control.focus();
                    await _pickFile(control);
                  },
                  child: StreamBuilder<bool>(
                    stream: control.focusChanges,
                    builder: (context, snapshot) {
                      final isFocused = control.hasFocus;
                      return Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 48),
                        padding: const EdgeInsets.all(12),
                        decoration: getThemedContainerDecoration(context,
                            hasError: hasError, isFocused: isFocused),
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
                                      : theme.hintColor,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.attach_file,
                              color: hasError
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (hasError) ...[
                  const SizedBox(height: 8),
                  Text(
                    (errorText ?? "").ctr,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
                const SizedBox(height: kFormFieldSpacing),
              ],
            );
          },
        );

  static Future<void> _pickFile(FormControl<String> control) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        control.updateValue(result.files.single.path!);
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }
}