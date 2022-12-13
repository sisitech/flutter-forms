import 'package:flutter/foundation.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'form_connect.dart';
import 'models.dart';

class FormController extends GetxController {
  final dynamic formItems;
  List<List<String>> formGroupOrder;
  final Map<String, dynamic>? extraFields;
  final bool? isValidateOnly;
  final String? url;
  final Function? PreSaveData;

  var isLoading = false.obs;
  FormProvider serv = Get.put<FormProvider>(FormProvider());

  List<FormItemField> fields = [];

  FormController(
      {required this.formItems,
      this.isValidateOnly,
      this.url,
      this.extraFields,
      this.PreSaveData,
      this.formGroupOrder = const []}) {
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
    var jsonForm = formItems["actions"]["POST"] as Map<String, dynamic>;
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
      dprint("Not valied");
      dprint(form.errors);
      form.markAllAsTouched();
      return;
    }
    // dprint({url, isValidateOnly});
    // dprint(extraFields);

    var data = preparePostData();
    try {
      isLoading.value = true;

      dprint("Making api vcall");
      var res = await serv.login(data);
      dprint(res.statusCode);
      dprint(res.body);
      dprint(res.isOk);
      dprint("Done with call");
      isLoading.value = false;
    } catch (e) {
      dprint("Error clals");
      isLoading.value = false;
      dprint(e);
    }

    dprint(data);
    dprint('Hello Reactive Forms!!!');
    update();
  }
}
