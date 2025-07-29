library flutter_form;

import 'dart:io';
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
            return _ImagePickerContent(field: field, fieldState: fieldState);
          },
        );
}

class _ImagePickerContent extends StatelessWidget {
  final FormItemField field;
  final ReactiveFormFieldState<String, String> fieldState;

  const _ImagePickerContent({
    required this.field,
    required this.fieldState,
  });

  @override
  Widget build(BuildContext context) {
    final inputCont = Get.find<InputController>(tag: field.name);
    final control = fieldState.control;

    String? errorText;
    if (control.errors.isNotEmpty) {
      errorText = control.errors.keys.join("\n");
    }
    bool hasError = (errorText?.isNotEmpty ?? false) && control.touched;
    bool hasSelectedImage = control.value?.isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Text(
          "${field.label}".ctr + " ${field.required ? '*' : ''}",
          style: Get.theme.inputDecorationTheme.labelStyle,
        ),
        const SizedBox(height: 8),

        // Conditional content based on selection state
        if (hasSelectedImage)
          _buildImagePreview(control, hasError, inputCont)
        else
          _buildImagePicker(control, hasError, inputCont),

        // Error display
        if (hasError) ...[
          const SizedBox(height: 8),
          Text(
            (errorText ?? "").ctr,
            style: TextStyle(color: Get.theme.colorScheme.error),
          ),
        ],

        const SizedBox(height: 20),
      ],
    );
  }

  bool _isLocalFile(String? value) {
    if (value == null || value.isEmpty) return false;
    try {
      return File(value).existsSync();
    } catch (e) {
      return false;
    }
  }

  Widget _buildErrorWidget(String? imagePath) {
    return Container(
      width: double.infinity,
      height: 150,
      color: Get.theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Get.theme.colorScheme.error,
          ),
          const SizedBox(height: 8),
          Text(
            "Failed to load image".ctr,
            style: TextStyle(
              color: Get.theme.colorScheme.error,
              fontSize: 12,
            ),
          ),
          if (imagePath != null) ...[
            const SizedBox(height: 4),
            Text(
              imagePath.length > 50
                  ? '...${imagePath.substring(imagePath.length - 47)}'
                  : imagePath,
              style: TextStyle(
                color: Get.theme.colorScheme.error,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImagePreview(
      FormControl<String> control, bool hasError, InputController inputCont) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              hasError ? Get.theme.colorScheme.error : Get.theme.primaryColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _isLocalFile(control.value)
                ? Image.file(
                    File(control.value!),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildErrorWidget(control.value);
                    },
                  )
                : Image.network(
                    control.value!,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 150,
                        color: Get.theme.colorScheme.surface,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildErrorWidget(control.value);
                    },
                  ),
          ),
          // Remove button
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  control.updateValue('');
                  control.focus();
                },
              ),
            ),
          ),
          // Edit/Replace button
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Get.theme.primaryColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () async {
                  inputCont.form?.unfocus();
                  await _showImageSourceSelector(Get.context!, control);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(
      FormControl<String> control, bool hasError, InputController inputCont) {
    return InkWell(
      onTap: () async {
        inputCont.form?.unfocus();
        await _showImageSourceSelector(Get.context!, control);
      },
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                hasError ? Get.theme.colorScheme.error : Get.theme.primaryColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 24,
                  color: Get.theme.primaryColor,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.photo_library,
                  size: 24,
                  color: Get.theme.primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Select ${field.label}".ctr,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: Get.theme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Tap to choose from camera or gallery".ctr,
              style: Get.theme.textTheme.bodySmall?.copyWith(
                color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

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
