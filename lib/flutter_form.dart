library flutter_form;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'input_controller.dart';
import 'models.dart';
import 'multiselect/multiselect.dart';
import 'utils.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
  showSomething() => "Wlecomec";
}

const Map<String, dynamic> actions = {
  "POST": {"": {}},
};
const Map<String, dynamic> defaultOptions = {
  "name": "",
  "actions": actions,
};

class MyCustomForm extends StatelessWidget {
  final String formTitle;
  final dynamic? formItems;
  final Widget? formHeader;
  final Widget? formFooter;
  final bool isValidateOnly;
  final Function? PreSaveData;
  final String? submitButtonText;
  final String? submitButtonPreText;
  final ContentType contentType;
  final Function? handleErrors;
  final Function? onSuccess;
  final Function? onControllerSetup;
  final String loadingMessage;
  FormStatus status;
  final Function? onStatus;

  final Map<String, dynamic>? instance;

  final String? url;
  final List<List<String>> formGroupOrder;

  final Map<String, dynamic>? extraFields;

  final String? instanceUrl;

  final Function? getDynamicUrl;

  MyCustomForm({
    super.key,
    required this.formTitle,
    this.formItems = defaultOptions,
    required this.formGroupOrder,
    this.formHeader,
    this.formFooter,
    this.extraFields,
    this.isValidateOnly = false,
    this.url,
    this.PreSaveData,
    this.onStatus,
    this.instanceUrl,
    this.getDynamicUrl,
    this.onControllerSetup,
    this.status = FormStatus.Add,
    this.loadingMessage = "Loading ...",
    this.handleErrors,
    this.submitButtonText = "",
    this.onSuccess,
    this.instance,
    this.submitButtonPreText,
    this.contentType = ContentType.json,
  }) {
    final controller = Get.put(
        FormController(
          formItems: formItems,
          formGroupOrder: formGroupOrder,
          extraFields: extraFields,
          PreSaveData: PreSaveData,
          loadingMessage: loadingMessage,
          isValidateOnly: isValidateOnly,
          instance: instance,
          instanceUrl: instanceUrl,
          url: url,
          getDynamicUrl: getDynamicUrl,
          status: status,
          onControllerSetup: onControllerSetup,
          onSuccess: onSuccess,
          contentType: contentType,
          handleErrors: handleErrors,
        ),
        tag: formTitle);

    if (onControllerSetup != null) {
      onControllerSetup!(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormController>(tag: formTitle);
    return GetBuilder(
        init: controller,
        builder: (_) {
          dprint("Rebuilding");
          return ReactiveForm(
            formGroup: controller.form,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: formHeader ??
                      Text(
                        submitButtonPreText ??
                            "${controller.status.statusDisplay()} $submitButtonText",
                        style: Get.theme.textTheme.titleLarge,
                      ),
                ),
                ...controller.formGroupOrder.map(
                    (rowElements) => getRowInputs(controller, rowElements)),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.errors.length,
                    itemBuilder: (context, index) {
                      return Text(
                        controller.errors[index],
                        style: TextStyle(color: Colors.red),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MySubmitButton(
                  formTitle: formTitle,
                  submitButtonPreText:
                      submitButtonPreText ?? controller.status.statusDisplay(),
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
              (field) => getInput(
                field,
              ),
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
Widget LabelWidget(FormItemField field) {
  return Text(
    labelName(field),
    style: Get.theme.inputDecorationTheme.labelStyle,
  );
}

getInputBasedOnType(FormItemField field) {
  // dprint("Getting the labelStyle");
  // dprint(Get.theme.textTheme.bodyText1);
  // dprint(Get.theme.inputDecorationTheme.labelStyle);
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
          maxLength: field.max_length,
          minLines: isTextArea ? 2 : 1,
          textInputAction:
              isTextArea ? TextInputAction.newline : TextInputAction.next,
          maxLines: isTextArea ? null : 1,
          obscureText: field.obscure ?? false,
          decoration: inputDecoration(field));
      break;
    case FieldType.boolean:
      reactiveInput = Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            LabelWidget(field),
            ReactiveCheckbox(
              formControlName: field.name,
            ),
          ],
        ),
      );
      break;
    case FieldType.date:
      reactiveInput = ReactiveDatePicker(
        formControlName: field.name,
        builder: (BuildContext context,
            ReactiveDatePickerDelegate<dynamic> picker, Widget? child) {
          dprint("Picker errprs");
          String? errorText;
          if (picker.control.errors != null) {
            errorText = picker.control?.errors.keys.join("\n");
          }
          bool hasError =
              (errorText?.isNotEmpty ?? false) && picker.control.touched;
          dprint(hasError);
          return GestureDetector(
            onTap: picker.showPicker,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LabelWidget(field),
                      IconButton(
                        onPressed: picker.showPicker,
                        icon: Icon(
                          Icons.date_range_outlined,
                          color: hasError ? Get.theme.errorColor : null,
                        ),
                      ),
                      Text(dateToCustomString(picker.control.value))
                    ],
                  ),
                  if (hasError)
                    Text(
                      errorText ?? "",
                      style: TextStyle(color: Get.theme.errorColor),
                    )
                ],
              ),
            ),
          );
          ;
        },
        firstDate: DateTime.now(),
        lastDate: DateTime.now(),
      );
      break;
    case FieldType.multifield:
      var inputCont = Get.put(
          InputController(
            field: field,
            fetchFirst: false,
          ),
          tag: field.name);

      reactiveInput = MultiSelectCustomField(
        formControlName: field.name,
        fildOption: field,
      );

      break;
    case FieldType.field:
      var inputCont = Get.put(InputController(field: field), tag: field.name);

      reactiveInput = Obx(
        () => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: LabelWidget(field),
              // Text(inputCont.isLoading.value ? 'Loading...' : labelName(field)),
            ),
            Expanded(
              child: ReactiveDropdownField(
                formControlName: field.name,
                items: inputCont.choices?.value ?? [],
              ),
            ),
          ],
        ),
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
          child: Text(controller!.isLoading == true
              ? controller!.loadingMessage
              : submitText)),
    );
  }

  void _onPressed() {
    // controller.form
    final controller = Get.find<FormController>(tag: formTitle);
    controller.submit();
  }
}
