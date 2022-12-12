library flutter_form;

import 'package:flutter/material.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:flutter_form/utils.dart';
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
  final Widget? formHeader;
  final Widget? formFooter;
  final List<List<String>> formGroupOrder;

  MyCustomForm(
      {super.key,
      required this.formTitle,
      this.formItems,
      required this.formGroupOrder,
      this.formHeader,
      this.formFooter}) {
    final controller = Get.put(
        FormController(formItems: formItems, formGroupOrder: formGroupOrder),
        tag: formTitle);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormController>(tag: formTitle);
    return GetBuilder(
        init: controller,
        builder: (_) {
          print("Rebuilding");
          return ReactiveForm(
            formGroup: controller.form,
            child: Column(
              children: <Widget>[
                formHeader ?? Container(),
                ...controller.formGroupOrder.map(
                    (rowElements) => getRowInputs(controller, rowElements)),
                const SizedBox(
                  height: 10,
                ),
                MySubmitButton(
                  formTitle: formTitle,
                ),
                formFooter ?? Container(),
              ],
            ),
          );
        });
    ;
  }
}

Widget getRowInputs(FormController controller, List<String> fieldNames) {
  var rowFields = controller.fields.where(
    (field) => fieldNames.contains(field.name),
  );
  dprint(rowFields);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...rowFields
            .map(
              (field) => getInput(field),
            )
            .toList()
      ],
    ),
  );
}

Widget getInput(FormItemField field) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: getInputBasedOnType(field),
    ),
  );
}

getInputBasedOnType(FormItemField field) {
  inputDecoration(field) => InputDecoration(
        labelText: field.label + "${field.required ? '*' : ''}",
        helperText: field.placeholder,
        // helperStyle: TextStyle(height: 0.7),
        // errorStyle: TextStyle(height: 0.7),
      );

  var defaultValidationMessage = {
    'required': (error) => 'The name must not be empty'
  };
  var requiredValidators = [
    Validators.required,
  ];
  var reactiveInput;
  switch (field.type) {
    case FieldType.string:
      reactiveInput = ReactiveTextField(
          formControlName: field.name,
          validationMessages: defaultValidationMessage,
          textInputAction: TextInputAction.next,
          decoration: inputDecoration(field));
      break;
    default:
      reactiveInput = ReactiveTextField(
        formControlName: field.name,
        validationMessages: defaultValidationMessage,
        textInputAction: TextInputAction.next,
        decoration: inputDecoration(field),
      );
  }
  return reactiveInput;
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
