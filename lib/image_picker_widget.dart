library flutter_form;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form/input_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
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
    final theme = Theme.of(context);

    String? errorText;
    if (control.errors.isNotEmpty) {
      errorText = control.errors.keys.join("\n");
    }
    bool hasError = (errorText?.isNotEmpty ?? false) && control.touched;
    bool hasSelectedImage = control.value?.isNotEmpty == true;

    return StreamBuilder<bool>(
      stream: control.focusChanges,
      builder: (context, snapshot) {
        final isFocused = control.hasFocus;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${field.label}".ctr + " ${field.required ? '*' : ''}",
              style: theme.inputDecorationTheme.labelStyle,
            ),
            const SizedBox(height: 8),
            if (hasSelectedImage)
              _buildImagePreview(context, control, hasError, isFocused, inputCont)
            else
              _buildImagePicker(context, control, hasError, isFocused, inputCont),
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
  }

  bool _isLocalFile(String? value) {
    if (value == null || value.isEmpty) return false;
    try {
      return File(value).existsSync();
    } catch (e) {
      return false;
    }
  }

  Widget _buildErrorWidget(BuildContext context, String? imagePath) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: 150,
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 8),
          Text(
            "Failed to load image".ctr,
            style: TextStyle(
              color: theme.colorScheme.error,
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
                color: theme.colorScheme.error,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context,
      FormControl<String> control, bool hasError, bool isFocused, InputController inputCont) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: 150,
      decoration: getThemedContainerDecoration(context, hasError: hasError, isFocused: isFocused),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: _isLocalFile(control.value)
                ? Image.file(
                    File(control.value!),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, error, stackTrace) {
                      return _buildErrorWidget(ctx, control.value);
                    },
                  )
                : Image.network(
                    control.value!,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    loadingBuilder: (ctx, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 150,
                        color: theme.colorScheme.surface,
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
                    errorBuilder: (ctx, error, stackTrace) {
                      return _buildErrorWidget(ctx, control.value);
                    },
                  ),
          ),
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
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () async {
                  control.focus();
                  await _showImageSourceSelector(context, control);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context,
      FormControl<String> control, bool hasError, bool isFocused, InputController inputCont) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () async {
        control.focus();
        await _showImageSourceSelector(context, control);
      },
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: getThemedContainerDecoration(context, hasError: hasError, isFocused: isFocused),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 24,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.photo_library,
                  size: 24,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Select ${field.label}".ctr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Tap to choose from camera or gallery".ctr,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
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
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }
}
