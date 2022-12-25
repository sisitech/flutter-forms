import 'package:flutter/material.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../input_controller.dart';
import '../models.dart';

class MultiSelectView extends StatelessWidget {
  /// The value of the Counter
  final FormChoice? value;

  /// The callback to notify that the user has pressed the increment button.
  final Function onChange;
  final InputController inputController;
  final FormItemField fieldOption;
  ReactiveFormFieldState<dynamic?, dynamic?> reactiveField;

  /// Creates a [Counter] instance.
  /// The [value] of the counter is required and must not by null.
  MultiSelectView(
      {super.key,
      this.value,
      required this.onChange,
      required this.inputController,
      required this.fieldOption,
      required this.reactiveField});

  selectStuff(FormChoice? formChoice) {
    onChange(formChoice);
  }

  @override
  Widget build(BuildContext context) {
    // dprint(context);
    dprint("Reveived erros");
    dprint(reactiveField.errorText);
    return Container(
      constraints: BoxConstraints(maxHeight: 500, minHeight: 50),
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: inputController.searchController,
              decoration: InputDecoration(
                // icon: Icon(Icons.person),
                suffixIcon: Icon(Icons.search),
                hintText: fieldOption?.placeholder ?? "",
                labelText: fieldOption.label,
                errorText: reactiveField.errorText,
              ),
              onChanged: inputController.onSearchChanged,
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                dprint("Valiadtin");
                return reactiveField.errorText;
              },
            ),
            if (inputController.isLoading.value)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 13),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(),
                ),
              ),
            if (inputController.noResults.value != "")
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${inputController.noResults.value}",
                    style: Get.theme.textTheme.caption,
                  ),
                  IconButton(
                    onPressed: () {
                      dprint("${inputController.noResults.value}");
                      inputController.noResults.value = "";
                    },
                    icon: const Icon(Icons.cancel),
                  )
                ],
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    var choice = inputController.formChoices.value[index];
                    // dprint(
                    //     "Changing... ${choice.value} ${inputController.formChoices.value}");
                    // dprint(inputController.selected?.value);

                    return GestureDetector(
                      onTap: () {
                        onChange(choice);
                      },
                      child: ListTile(
                        title: Text("${choice.display_name}"),
                        trailing: inputController.selected?.value?.value ==
                                choice.value
                            ? Icon(
                                Icons.check_circle,
                              )
                            : null,
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: inputController.choices.length,
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}

class MultiSelectCustomField extends ReactiveFormField<dynamic?, dynamic?> {
  MultiSelectCustomField({
    required String formControlName,
    required FormItemField fildOption,
  }) : super(
            formControlName: formControlName,
            builder: (ReactiveFormFieldState<dynamic?, dynamic?> field) {
              dprint("Errors are");
              dprint(field.errorText);
              dprint("Reactive forms event");
              // dprint(field.valueAccessor.runtimeType);
              // dprint(field);
              // var tag = "${formControlName}${formName}";
              var controller = Get.find<InputController>(tag: fildOption.name);

              // make sure never to pass null value to the Counter widget.
              final fieldValue = field.value;
              FormChoice? valueChoice;
              // dprint("Field Value");
              // dprint(fieldValue);

              if (fieldValue == null) {
                valueChoice = null;
              } else {
                var filt = controller.formChoices.value
                    ?.where((element) => "${element.value}" == fieldValue);
                if (filt!.isNotEmpty) {
                  valueChoice = filt.first;
                } else {
                  /// Maintain state when resizing
                  valueChoice = controller.selected.value;
                }
              }
              controller.selectValue(valueChoice);

              return Container(
                constraints:
                    BoxConstraints(maxHeight: Get.height, minHeight: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MultiSelectView(
                      value: valueChoice,
                      inputController: controller,
                      fieldOption: fildOption,
                      reactiveField: field,
                      onChange: (value) {
                        if (value == null) {
                          field.didChange("$value");
                        } else {
                          // controller.selected.value = valueChoice;a
                          field.didChange("${value?.value}");
                        }
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (fieldValue != null)
                          _buildChip(valueChoice?.display_name ?? "O", field)
                        // Text(
                        //     "Selectd ${controller.selected?.value} ${fieldValue} : ${fieldValue}")
                      ],
                    )
                  ],
                ),
              );
            });

  @override
  ReactiveFormFieldState<dynamic?, dynamic?> createState() =>
      ReactiveFormFieldState<dynamic?, dynamic?>();
}

Widget _buildChip(String label, field) {
  return Card(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Chip(
          labelPadding: EdgeInsets.all(2.0),
          label: Text(
            label,
          ),
        ),
        IconButton(
          onPressed: () {
            field.didChange(null);
          },
          icon: Icon(Icons.cancel),
          // color: Get.theme.errorColor,
        )
      ],
    ),
  );
}
