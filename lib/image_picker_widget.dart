library flutter_form;

import 'package:flutter/material.dart';
import 'package:flutter_form/input_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ImagePickerWidget extends ReactiveFormField<String, String> {
  final FormItemField field;

  ImagePickerWidget({
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
                : "Select Image".ctr;

            return GestureDetector(
              onTap: () async {
                inputCont.form?.unfocus();
                await _showImageSourceSelector(Get.context!, control);
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
                            Text(
                              "${field.label}".ctr + " ${field.required ? '*' : ''}",
                              style: Get.theme.inputDecorationTheme.labelStyle,
                            ),
                            Row(
                              children: [
                                Text(displayText),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.image,
                                  color: hasError
                                      ? Get.theme.colorScheme.error
                                      : null,
                                ),
                              ],
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

  static Future<void> _showImageSourceSelector(
      BuildContext context, FormControl<String> control) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text("Camera".ctr),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera(control);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text("Gallery".ctr),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery(control);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> _pickImageFromCamera(FormControl<String> control) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        control.updateValue(image.path);
        control.focus();
      }
    } catch (e) {
      print('Error picking image from camera: $e');
    }
  }

  static Future<void> _pickImageFromGallery(FormControl<String> control) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        control.updateValue(image.path);
        control.focus();
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }
}