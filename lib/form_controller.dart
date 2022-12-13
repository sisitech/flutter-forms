import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'form_connect.dart';
import 'models.dart';

class FormController extends GetxController {
  final Map<String, dynamic> formItems;
  List<List<String>> formGroupOrder;
  final Map<String, dynamic>? extraFields;
  final bool isValidateOnly;
  final String? url;
  final Function? PreSaveData;
  final ContentType contentType;
  final Function? handleErrors;
  final String loadingMessage;
  final Function? onSuccess;

  var isLoading = false.obs;
  FormProvider serv = Get.put<FormProvider>(FormProvider());

  List<FormItemField> fields = [];
  List<String> errors = [];
  FormController(
      {required this.formItems,
      this.isValidateOnly = false,
      this.url,
      this.extraFields,
      this.onSuccess,
      this.handleErrors,
      this.PreSaveData,
      required this.loadingMessage,
      required this.contentType,
      this.formGroupOrder = const []}) {
    // dprint(formItems);
    dprint("Initialized this controller for me..");
  }

  @override
  void onInit() {
    super.onInit();
    setUpForm();
  }

  var form = FormGroup({});

  setUpForm() {
    fields = [];
    dprint("Getting options");
    var jsonForm = formItems["actions"]["POST"] as Map<String, dynamic>;
    // dprint(jsonForm);
    var possibleFields = [];
    // dprint(formGroupOrder);
    formGroupOrder.forEach((row) {
      possibleFields.addAll(row);
    });
    dprint(possibleFields);
    possibleFields.forEach((value) {
      FormItemField field;
      //  = FormItemField.fromJson({"name": key, ...value});
      if (jsonForm.containsKey(value)) {
        field = FormItemField.fromJson({"name": value, ...jsonForm[value]});
      } else {
        field = FormItemField(
          name: value,
          label: value,
          type: FieldType.string,
        );
      }
      fields.add(field);
      form.addAll({
        value: getFormControl(field),
      });
      // if (!field.read_only && possibleFields.contains(field.name)) {
      //   fields.add(field);
      //   form.addAll({
      //     key: getFormControl(field),
      //   });
      // }
    });
    update();
  }

  getFormControl(FormItemField field) {
    var validators = getFieldValidators(field);
    var formControl;
    switch (field.type) {
      case FieldType.string:
        formControl = FormControl<String>(validators: validators);
        break;
      case FieldType.boolean:
        formControl = FormControl<bool>(validators: validators);
        break;
      case FieldType.field:
        formControl = FormControl<Object>(validators: validators);
        break;
      default:
        formControl = FormControl(validators: validators);
    }
    return formControl;
  }

  getFieldValidators(FormItemField field) {
    List<Map<String, dynamic>? Function(AbstractControl<dynamic>)> validators =
        [];
    if (field.required) {
      validators.add(Validators.required);
    }
    return validators;
  }

  preparePostData() {
    var value = {...form.value, ...extraFields ?? {}};
    if (PreSaveData != null) {
      value = PreSaveData!(value);
    }
    return value;
  }

  submit() async {
    if (!form.valid) {
      // dprint("Not valied");
      // dprint(form.errors);
      form.markAllAsTouched();
      return;
    }
    // dprint({url, isValidateOnly});
    // dprint(extraFields);
    const successStatusCodes = [200, 201, 204];
    const errorStatusCodes = [400, 401, 403];
    var data = preparePostData();
    dprint(isValidateOnly);
    if (isValidateOnly) {
      if (onSuccess != null) {
        onSuccess!(data);
      }
      return;
    }
    try {
      isLoading.value = true;
      // dprint("Making api vcall");
      errors = [];
      update();
      Response res;
      if (contentType == ContentType.form_url_encoded) {
        // dprint("Url encoded");
        res = await serv.formPostUrlEncoded(url, data);
      } else {
        // dprint("None url encoded");
        res = await serv.formPost(url, data);
      }
      isLoading.value = false;
      if (successStatusCodes.contains(res.statusCode)) {
        if (onSuccess != null) {
          onSuccess!(res.body);
        }
      } else if (errorStatusCodes.contains(res.statusCode)) {
        try {
          // dprint("Done with call");
          var formErrors = res.body as Map<String, dynamic>;
          // dprint(formErrors);
          formErrors.forEach((key, value) {
            if (fields.map((e) => e.name).contains(key)) {
              String display = getErrorDisplay(value);
              form.control(key).setErrors({display: "dada"});
            } else {
              String display = getErrorDisplay(value);
              if (handleErrors == null) {
                errors.add(display);
              }
            }
          });
          if (handleErrors != null) {
            String display = handleErrors!(formErrors);
            errors.add(display);
          }
        } catch (e) {
          dprint(e);
        }
      }
    } catch (e) {
      dprint("Error clals");
      isLoading.value = false;
      dprint(e);
    }

    // dprint(data);
    // dprint('Hello Reactive Forms!!!');
    update();
  }

  getErrorDisplay(dynamic value) {
    String display = "";
    if (value.runtimeType == List<dynamic>) {
      display = value.join("\n");
    } else {
      display = value;
    }
    return display;
  }
}
