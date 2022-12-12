import 'package:flutter/foundation.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'models.dart';

class FormController extends GetxController {
  final dynamic formItems;
  List<List<String>> formGroupOrder;

  List<FormItemField> fields = [];

  FormController({required this.formItems, this.formGroupOrder = const []}) {
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
    jsonForm.forEach((key, value) {
      var field = FormItemField.fromJson({"name": key, ...value});
      if (!field.read_only && possibleFields.contains(field.name)) {
        fields.add(field);
        form.addAll({key: FormControl<String>()});
      }
    });
    update();
  }

  submit() {
    if (!form.valid) {
      dprint("Not valied");
      dprint(form.errors);
      form.markAllAsTouched();
    }
    dprint(form.value);
    form.control("name").setErrors({"required": "Already taken."});
    form.control("name").markAsTouched();
    // var nameField = form.control("name");
    // print(nameField.disabled);

    // nameField.markAsDisabled();
    // print();
    // print(nameField.disabled);
    dprint('Hello Reactive Forms!!!');
    update();
  }
}
