library flutter_form;

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'models.dart';

extension MyStringExt on String {
  String toUrlNoSlash() {
    if (this.endsWith("/")) {
      return this.substring(0, this.length - 1);
    }
    return this;
  }

  String toUrlWithSlash() {
    return "${this.toUrlNoSlash()}/";
  }
}

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

getFieldValidators(FormItemField field) {
  List<Map<String, dynamic>? Function(AbstractControl<dynamic>)> validators =
      [];
  if (field.required) {
    validators.add(Validators.required);
  }
  return validators;
}

FormControl getFormControl(FormItemField field) {
  var validators = getFieldValidators(field);
  // Setup INput COntroller base on

  var formControl;
  switch (field.type) {
    case FieldType.string:
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
    default:
      formControl = FormControl(validators: validators);
  }
  return formControl;
}
