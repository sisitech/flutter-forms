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
  final bool? isValidateOnly;
  final Function? PreSaveData;
  final String? submitButtonText;
  final String? submitButtonPreText;

  final String? url;
  final List<List<String>> formGroupOrder;

  final Map<String, dynamic>? extraFields;

  MyCustomForm({
    super.key,
    required this.formTitle,
    this.formItems,
    required this.formGroupOrder,
    this.formHeader,
    this.formFooter,
    this.extraFields,
    this.isValidateOnly = false,
    this.url,
    this.PreSaveData,
    this.submitButtonText = "",
    this.submitButtonPreText = "Add",
  }) {
    final controller = Get.put(
        FormController(
          formItems: formItems,
          formGroupOrder: formGroupOrder,
          extraFields: extraFields,
          PreSaveData: PreSaveData,
        ),
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
                  submitButtonPreText: submitButtonPreText,
                  submitButtonText: submitButtonText,
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

labelName(field) => field.label + "${field.required ? '*' : ''}";
inputDecoration(field) => InputDecoration(
      labelText: labelName(field),
      helperText: field.placeholder,
      // helperStyle: TextStyle(height: 0.7),
      // errorStyle: TextStyle(height: 0.7),
    );
getInputBasedOnType(FormItemField field) {
  var defaultValidationMessage = {
    'required': (error) => 'This field must not be empty'
  };
  Widget reactiveInput;
  switch (field.type) {
    case FieldType.string:
      var isTextArea = field.max_length != null && field.max_length! > 300;
      reactiveInput = ReactiveTextField(
          formControlName: field.name,
          validationMessages: defaultValidationMessage,
          textInputAction: TextInputAction.next,
          maxLength: field.max_length,
          maxLines: isTextArea ? 3 : 1,
          decoration: inputDecoration(field));
      break;
    case FieldType.boolean:
      reactiveInput = Row(
        children: [
          Text(labelName(field)),
          ReactiveCheckbox(
            formControlName: field.name,
          ),
        ],
      );
      break;
    case FieldType.field:
      reactiveInput = ReactiveDropdownField(
        formControlName: field.name,
        items: field.choices!
            .map((e) => DropdownMenuItem(
                  value: e.value,
                  child: Text(e.display_name),
                ))
            .toList(),
      );
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
  final String? submitButtonText;
  final String? submitButtonPreText;
  final String formTitle;
  MySubmitButton({
    super.key,
    required this.formTitle,
    this.submitButtonText,
    this.submitButtonPreText,
  }) {
    controller = Get.find<FormController>(tag: formTitle);
  }

  @override
  Widget build(BuildContext context) {
    var submitText = "${submitButtonPreText} ${submitButtonText}";
    return Obx(
      () => ElevatedButton(
          onPressed: controller!.isLoading == true ? null : _onPressed,
          child:
              Text(controller!.isLoading == true ? "Loading..." : submitText)),
    );
  }

  void _onPressed() {
    final controller = Get.find<FormController>(tag: formTitle);
    // controller.form
    controller.submit();
  }
}
