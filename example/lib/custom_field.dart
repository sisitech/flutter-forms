import 'package:flutter/material.dart';
import 'package:flutter_form/custom_input.dart';
import 'package:flutter_form/input_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/multiselect/multiselect.dart';
import 'package:flutter_form/utils.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:form_example/options.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomFieldForm extends StatefulWidget {
  const CustomFieldForm({super.key});

  @override
  State<CustomFieldForm> createState() => _CustomFieldFormState();
}

class _CustomFieldFormState extends State<CustomFieldForm> {
  final form = FormGroup({
    'counter': FormControl<int>(value: 2),
    'name': FormControl<String>(),
    'role': FormControl<String?>(),
  });
  var contactField = FormItemField.fromJson({
    "name": "name",
    "type": "multifield",
    "required": false,
    "read_only": false,
    "label": "Contact name",
    "url": "api/v1/users",
    "display_name": "username",
    "search_field": "username",
    "max_length": 45,
    "placeholder": "The name of the customer to deliver to"
  });
  var roleField = FormItemField.fromJson({
    "name": "role",
    "type": "field",
    "required": false,
    "read_only": false,
    "label": "Role",
    "max_length": 4,
    "choices": [
      {"value": "TSC", "display_name": "TSC"},
      {"value": "BRD", "display_name": "BOM"}
    ]
  });

  @override
  Widget build(BuildContext context) {
    var field = contactField;
    var inputCont = Get.put(InputController(field: field, fetchFirst: false),
        tag: field.name);

    return Center(
      child: ReactiveForm(
        formGroup: this.form,
        child: Column(
          children: [
            ReactiveValueListenableBuilder<int>(
                formControlName: 'counter',
                builder: (context, control, child) {
                  return Text(
                      control.isNotNull ? control.value.toString() : '0');
                }),
            ReactiveCounterField(
              formControlName: "counter",
            ),
            MultiSelectCustomField(
              // formName: "formane",
              // initalChoices: [
              //   FormChoice(display_name: "ABC", value: "A"),
              //   FormChoice(display_name: "Units", value: "U")
              // ],
              formControlName: field.name, fildOption: field,
            ),
            ElevatedButton(
                onPressed: () {
                  dprint(this.form.value);
                },
                child: Text("Submit".tr))
          ],
        ),
      ),
    );
  }
}
