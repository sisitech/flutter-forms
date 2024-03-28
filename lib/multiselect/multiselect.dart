import 'package:flutter/material.dart';
import 'package:flutter_form/utils.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../input_controller.dart';
import '../models.dart';

class MultiSelectView extends StatelessWidget {
  /// The value of the Counter
  final List<FormChoice>? value;

  final Function onChange;
  final InputController inputController;
  final FormItemField fieldOption;
  ReactiveFormFieldState<dynamic?, dynamic?> reactiveField;

  MultiSelectView({
    super.key,
    this.value,
    required this.onChange,
    required this.inputController,
    required this.fieldOption,
    required this.reactiveField,
  });

  selectStuff(FormChoice? formChoice) {
    onChange(formChoice);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 500, minHeight: 50),
      child: Obx(() {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: inputController.searchController,
                decoration: InputDecoration(
                  // icon: Icon(Icons.person),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Get.theme.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Get.theme.primaryColor.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
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
                  // dprint("Valiadtin");
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
                        // dprint("${inputController.noResults.value}");
                        inputController.cancelNoResults();
                      },
                      icon: const Icon(Icons.cancel),
                    )
                  ],
                ),
              Column(
                children: [
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
                          // dprint(inputController.selected?.value)
                          dprint("Changin values");

                          return GestureDetector(
                            onTap: () {
                              onChange(choice);
                            },
                            child: ListTile(
                              title: Text("${choice.display_name}"),
                              trailing: inputController.selectedItems?.value
                                          ?.map((e) => e.value)
                                          .contains(choice.value) ??
                                      false
                                  ? const Icon(
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
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}

updateFieldValue(InputController controller, FormChoice? formChoice,
    ReactiveFormFieldState<dynamic?, dynamic?> field) {
  if (formChoice?.value == null) {
    dprint("Muliselect value null. Ignored");
    return;
  }
  // dprint(formChoice?.display_name);
  // dprint(formChoice?.value);
  if (controller.field.multiple) {
    var value = formChoice?.value;
    var currentvalues = field.value ?? [];
    // List<String> values = [...currentvalues];
    List<String> values = field.value ?? [];
    dprint(values.runtimeType);
    dprint("Current values are $values");
    if (!values.contains(value)) {
      values.add("$value");
    }
    dprint("New $values");
    field.didChange(values);
  } else {
    field.didChange("${formChoice?.value}");
  }
  field.setState(() {});
}

removeFieldValue(InputController controller, FormChoice choice,
    ReactiveFormFieldState<dynamic?, dynamic?> field) {
  dprint("Removing ${choice.value}");
  if (controller.field.multiple) {
    // List<String> values = [...(field.value as List<String>)];

    List<String> values = field.value ?? [];
    if (values.contains("${choice.value}")) {
      values.remove("${choice.value}");
    }
    dprint("Remaining values $values");
    field.didChange(values);
  } else {
    field.didChange(null);
  }
  field.setState(() {});
}

class MultiSelectCustomField extends ReactiveFormField<dynamic?, dynamic?> {
  MultiSelectCustomField({
    required String formControlName,
    required FormItemField fildOption,
  }) : super(
            formControlName: formControlName,
            builder: (ReactiveFormFieldState<dynamic?, dynamic?> field) {
              // dprint("Errors are");
              // dprint(field.errorText);
              // dprint("Reactive forms event");
              // dprint(field.valueAccessor.runtimeType);
              // dprint(field).na;
              // var tag = "${formControlName}${formName}";
              var controller = Get.find<InputController>(tag: fildOption.name);

              // make sure never to pass null value to the Counter widget.
              final fieldValue = field.value;
              List<FormChoice> valueChoice = [];

              bool isMultiple = controller.field.multiple;
              dprint(fieldValue);
              var possibleChoices = controller.getAllPosibleOptions();

              if (fieldValue == null) {
                valueChoice = [];
              } else {
                dprint("Updaint choicess");
                var currentChoices = [];
                List<FormChoice> filt = [];

                if (isMultiple) {
                  for (var item in fieldValue) {
                    filt.add(controller.getChoice(item));
                  }
                } else {
                  filt = [controller.getChoice(fieldValue)];
                }
                valueChoice = filt;
              }
              dprint(valueChoice);
              controller.selectValue(valueChoice);
              dprint("Field value $fieldValue");
              dprint("Field value ${field.value}");
              return Container(
                padding: EdgeInsets.only(
                  bottom: 20,
                ),
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
                        dprint("Select vlaihdi $value");
                        updateFieldValue(controller, value, field);
                      },
                    ),
                    if (valueChoice.isNotEmpty)
                      Column(
                        // physics: NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                        // gridDelegate:
                        //     const SliverGridDelegateWithFixedCrossAxisCount(
                        //   crossAxisCount: 2,
                        //   mainAxisExtent: 50,
                        // ),
                        children: [
                          if (fieldValue != null)
                            ..._buildChip(controller, valueChoice, field),
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

List<Widget> _buildChip(InputController controller, List<FormChoice> choices,
    ReactiveFormFieldState<dynamic, dynamic> field,
    {int rowCount = 2}) {
  List<List<FormChoice>> groupedRows =
      List.generate((choices.length / rowCount).ceil(), (index) {
    int startIndex = index * rowCount;
    int endIndex = (index + 1) * rowCount;
    return choices.sublist(
        startIndex, endIndex < choices.length ? endIndex : choices.length);
  });
  // dprint(groupedRows);
  return groupedRows.map((rowChoices) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: rowChoices
            .map(
              (choice) => Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      choice.display_name,
                    ),
                    IconButton(
                      onPressed: () {
                        removeFieldValue(controller, choice, field);
                      },
                      icon: Icon(Icons.cancel),
                      // color: Get.theme.errorColor,
                    ),
                  ],
                ),
              ),
            )
            .toList());
  }).toList();
}
