library flutter_form;

import 'package:flutter/material.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'models.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
  showSomething() => "Wlecomec";
}

class MyCustomForm extends StatelessWidget {
  final String formTitle;
  final dynamic formItems;
  final List<List<String>> formGroupOrder;

  MyCustomForm(
      {super.key,
      required this.formTitle,
      this.formItems,
      required this.formGroupOrder}) {
    final controller = Get.put(
        FormController(formItems: formItems, formGroupOrder: formGroupOrder),
        tag: formTitle);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormController>(tag: formTitle);
    // const fields=form

    return GetBuilder(
        init: controller,
        builder: (_) {
          print("Rebuilding");
          return ReactiveForm(
            formGroup: controller.form,
            child: Column(
              children: <Widget>[
                ...controller.fields
                    .map(
                      (field) => getInput(field),
                    )
                    .toList(),
                const SizedBox(
                  height: 10,
                ),
                MySubmitButton(
                  formTitle: formTitle,
                )
              ],
            ),
          );
        });
    ;
  }
}

Widget getInput(FormItemField field) {
  return ReactiveTextField(
    formControlName: field.name,
    validationMessages: {'required': (error) => 'The name must not be empty'},
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      labelText: field.label + "${field.required ? '*' : ''}",
      helperText: field.placeholder,
      helperStyle: TextStyle(height: 0.7),
      errorStyle: TextStyle(height: 0.7),
    ),
  );
}

class MySubmitButton extends StatelessWidget {
  FormController? controller;
  final String formTitle;
  MySubmitButton({super.key, required this.formTitle}) {
    controller = Get.find<FormController>(tag: formTitle);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(child: Text('Submit'), onPressed: _onPressed);
  }

  void _onPressed() {
    final controller = Get.find<FormController>(tag: formTitle);
    // controller.form
    controller.submit();
  }
}
