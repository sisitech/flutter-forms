library flutter_form;

import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'models.dart';

getFullInstanceUrl(String url, instanceId) {
  return "${url.toUrlNoSlash()}/$instanceId/";
}

extension MyDateExtenson on DateTime {
  String toCustomString() {
    var format = DateFormat.yMd();
    return format.format(this);
  }
}

String dateToCustomString(DateTime? date) {
  if (date == null) {
    return "";
  }
  var format = DateFormat('EEE, MMM d, ' 'yyyy');
  return format.format(date);
}

List<Validator<dynamic>> getFieldValidators(FormItemField field) {
  // List<Map<String, dynamic>? Function(AbstractControl<dynamic>)> validators =
  //     [];
  List<Validator<dynamic>> validators = [];
  if (field.required) {
    validators.add(Validators.required);
  }
  return validators;
}

FormControl getFormControl(FormItemField field) {
  List<Validator<dynamic>> validators = getFieldValidators(field);
  // Setup INput COntroller base on

  var formControl;
  switch (field.type) {
    case FieldType.string:
    case FieldType.alphabets:
      formControl = FormControl<String>(validators: validators);
      break;
    case FieldType.email:
      validators.add(Validators.email);
      formControl = FormControl<String>(validators: validators);
      break;
    case FieldType.integer:
      formControl = FormControl<int>(validators: validators);
      break;
    case FieldType.float:
      formControl = FormControl<double>(validators: validators);
      break;
    case FieldType.choice:
      formControl = FormControl<String>(validators: validators);
      break;
    case FieldType.boolean:
      formControl = FormControl<bool>(value: false, validators: validators);
      break;
    case FieldType.field:
      formControl = FormControl<Object>(validators: validators);
      break;
    case FieldType.multifield:
      // var inputCont = Get.put(
      //     InputController(field: field, fetchFirst: false, form: form),
      //     tag: field.name);
      // var inputContq =
      //     Get.put(InputController(field: field), tag: field.name);

      if (field.multiple) {
        formControl = FormControl<List<String>?>(validators: validators);
      } else {
        formControl = FormControl<String?>(validators: validators);
      }

      break;
    case FieldType.date:
      formControl = FormControl<DateTime>(validators: validators);
      break;
    case FieldType.datetime:
      formControl = FormControl<DateTime>(validators: validators);
      break;
    case FieldType.time:
      formControl = FormControl<DateTime>(validators: validators);
      break;
    case FieldType.file:
      formControl = FormControl<String>(validators: validators);
      break;
    case FieldType.image:
      formControl = FormControl<String>(validators: validators);
      break;
    default:
      formControl = FormControl(validators: validators);
  }
  return formControl;
}

/// Standard spacing between form fields
const double kFormFieldSpacing = 16.0;

/// Extracts border styling from InputDecorationTheme for custom containers
/// (date pickers, file pickers, boolean fields, etc.)
BoxDecoration getThemedContainerDecoration(
  BuildContext context, {
  bool hasError = false,
  bool isFocused = false,
}) {
  final theme = Theme.of(context);
  final inputTheme = theme.inputDecorationTheme;

  // Select border based on state (matching TextField behavior)
  InputBorder? themeBorder;
  if (isFocused && hasError) {
    themeBorder = inputTheme.focusedErrorBorder ?? inputTheme.errorBorder ?? inputTheme.border;
  } else if (isFocused) {
    themeBorder = inputTheme.focusedBorder ?? inputTheme.border;
  } else if (hasError) {
    themeBorder = inputTheme.errorBorder ?? inputTheme.border;
  } else {
    themeBorder = inputTheme.enabledBorder ?? inputTheme.border;
  }

  Color borderColor = theme.colorScheme.outline;
  double borderWidth = 1.0;

  // Determine border color based on state
  if (hasError) {
    borderColor = theme.colorScheme.error;
  } else if (isFocused) {
    borderColor = theme.colorScheme.primary;
  }

  if (themeBorder is OutlineInputBorder) {
    final borderRadius = themeBorder.borderRadius;
    // Use theme border color if available, otherwise use state-based color
    if (themeBorder.borderSide.color != const Color(0xFF000000)) {
      borderColor = hasError ? theme.colorScheme.error : themeBorder.borderSide.color;
    }
    borderWidth = themeBorder.borderSide.width;
    return BoxDecoration(
      border: Border.all(color: borderColor, width: borderWidth),
      borderRadius: borderRadius,
    );
  } else if (themeBorder is UnderlineInputBorder) {
    if (themeBorder.borderSide.color != const Color(0xFF000000)) {
      borderColor = hasError ? theme.colorScheme.error : themeBorder.borderSide.color;
    }
    borderWidth = themeBorder.borderSide.width;
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(color: borderColor, width: borderWidth),
      ),
    );
  }

  // Default fallback - underline style
  return BoxDecoration(
    border: Border(
      bottom: BorderSide(color: borderColor, width: borderWidth),
    ),
  );
}
