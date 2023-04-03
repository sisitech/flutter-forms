library flutter_form;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:flutter_form/utils.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/network_status/network_status_controller.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_utils/extensions/date_extensions.dart';
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
  final String? formTitle;
  final String name;
  final dynamic? formItems;
  final Widget? formHeader;
  final Widget? formFooter;
  final bool isValidateOnly;
  final Function? PreSaveData;
  final String? submitButtonText;
  final String? submitButtonPreText;
  final ContentType contentType;
  final Function? handleErrors;
  final Function(dynamic data)? onSuccess;
  final Function(dynamic data)? onOfflineSuccess;
  final Function? onControllerSetup;
  final Function? onFormItemTranform;
  late String storageContainer;
  late String offlineStorageContainer;
  late bool enableOfflineMode;
  late bool enableOfflineSave;
  late bool? showOfflineMessage;
  final Function(Map<String, dynamic>)? customDataValidation;

  final Function(Map<String, dynamic>)? validateOfflineData;

  final String loadingMessage;
  FormStatus status;
  final Function? onStatus;

  final Map<String, dynamic>? instance;

  final String? url;
  final List<List<String>> formGroupOrder;

  final Map<String, dynamic>? extraFields;

  final String? instanceUrl;

  final Function? getDynamicUrl;
  final Function? getOfflineName;
  TextStyle? formTitleStyle;

  MyCustomForm({
    super.key,
    this.formTitle,
    this.formItems = defaultOptions,
    required this.formGroupOrder,
    this.formHeader,
    this.showOfflineMessage = true,
    this.enableOfflineMode = false,
    this.enableOfflineSave = false,
    this.validateOfflineData,
    this.customDataValidation,
    this.formFooter,
    this.formTitleStyle,
    this.extraFields,
    this.isValidateOnly = false,
    this.url,
    required this.name,
    this.getOfflineName,
    this.onOfflineSuccess,
    this.PreSaveData,
    this.storageContainer = "GetStorage",
    this.offlineStorageContainer = "GetStorage",
    this.onStatus,
    this.instanceUrl,
    this.getDynamicUrl,
    this.onFormItemTranform,
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
          name: name,
          getOfflineName: getOfflineName,
          storageContainer: storageContainer,
          formGroupOrder: formGroupOrder,
          enableOfflineSave: enableOfflineSave,
          customDataValidation: customDataValidation,
          extraFields: extraFields,
          PreSaveData: PreSaveData,
          showOfflineMessage: showOfflineMessage,
          enableOfflineMode: enableOfflineMode,
          validateOfflineData: validateOfflineData,
          loadingMessage: loadingMessage,
          offlineStorageContainer: offlineStorageContainer,
          isValidateOnly: isValidateOnly,
          instance: instance,
          instanceUrl: instanceUrl,
          url: url,
          onOfflineSuccess: onOfflineSuccess,
          onFormItemTranform: onFormItemTranform,
          getDynamicUrl: getDynamicUrl,
          status: status,
          onControllerSetup: onControllerSetup,
          onSuccess: onSuccess,
          contentType: contentType,
          handleErrors: handleErrors,
        ),
        tag: name);

    if (onControllerSetup != null) {
      onControllerSetup!(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormController>(tag: name);
    return GetBuilder(
        init: controller,
        builder: (_) {
          // dprint("Rebuilding");
          return ReactiveForm(
            formGroup: controller.form,
            child: Column(
              children: <Widget>[
                if (formTitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: formHeader ??
                        Text(
                          formTitle ?? "",
                          style: formTitleStyle,
                        ),
                  ),
                ...controller.formGroupOrder.map(
                    (rowElements) => getRowInputs(controller, rowElements)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.errors.length,
                    itemBuilder: (context, index) {
                      return Text(
                        controller.errors[index].ctr,
                        style: TextStyle(color: Colors.red),
                      );
                    },
                  ),
                ),
                if (controller.errors.isNotEmpty)
                  const SizedBox(
                    height: 10,
                  ),
                MySubmitButton(
                  name: name,
                  enableOfflineSave: enableOfflineMode,
                  submitButtonPreText:
                      (submitButtonPreText ?? controller.status.statusDisplay())
                          .ctr,
                  submitButtonText: submitButtonText?.ctr,
                ),
                const SizedBox(
                  height: 10,
                ),
                formFooter ?? Container(),
              ],
            ),
          );
        });
    ;
  }
}

Widget getRowInputs(FormController controller, List<String> fieldNames,
    {index = 1}) {
  var rowFields = controller.fields.where(
    (field) => fieldNames.contains(field.name),
  );
  // dprint(rowFields);
  return Padding(
    padding: const EdgeInsets.only(top: 20),
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
  // dprint(field.name);
  // dprint(field.hasController);

  if (field.hasController) {
    var inputCont = Get.find<InputController>(tag: field.name);

    return Obx(() {
      return !inputCont.visible.value
          ? SizedBox(width: 0, height: 0)
          : Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: getInputBasedOnType(field),
              ),
            );
    });
  }

  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: getInputBasedOnType(field),
    ),
  );
}

labelName(field) => "${field.label}".ctr + " ${field.required ? '*' : ''}";

inputDecoration(field) => InputDecoration(
      labelText: labelName(field),
      helperText: "${field.placeholder ?? ''}".ctr,
      counterText: "",
      // helperStyle: TextStyle(height: 0.7),
      // errorStyle: TextStyle(height: 0.7),
    );
Widget LabelWidget(FormItemField field) {
  // dprint(labelName(field));
  return Text(
    labelName(field),
    style: Get.theme.inputDecorationTheme.labelStyle,
  );
}

parseDateFromString(String? dateString, DateTime defaultDate) {
  if (dateString?.isNotEmpty ?? false) {
    DateTime? parsedDate = dateString?.toDate;
    if (parsedDate != null) {
      return parsedDate;
    }
  }
  return defaultDate;
}

getInputBasedOnType(FormItemField field) {
  // dprint("Getting the labelStyle");
  // dprint(Get.theme.textTheme.bodyText1);
  // dprint(Get.theme.inputDecorationTheme.labelStyle);
  var defaultValidationMessage = {'required': (error) => 'empty_field'.ctr};
  dprint(field.start_value);
  dprint(field.end_value);
  var start_date = parseDateFromString(
      field.start_value, DateTime.now().add(const Duration(days: -10000)));
  var end_date = parseDateFromString(field.end_value, DateTime.now());

  Widget reactiveInput;
  switch (field.type) {
    case FieldType.alphabets:
      reactiveInput = ReactiveTextField(
          formControlName: field.name,
          validationMessages: defaultValidationMessage,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
          ],
          decoration: inputDecoration(field));
      break;

    case FieldType.float:
    case FieldType.integer:
      reactiveInput = ReactiveTextField(
          formControlName: field.name,
          validationMessages: defaultValidationMessage,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: inputDecoration(field));
      break;
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelWidget(field),
            ReactiveCheckbox(
              formControlName: field.name,
              activeColor: Get.theme.primaryColor,
            ),
          ],
        ),
      );
      break;
    case FieldType.date:
      reactiveInput = ReactiveDatePicker(
        formControlName: field.name.ctr,
        builder: (BuildContext context,
            ReactiveDatePickerDelegate<dynamic> picker, Widget? child) {
          // dprint("Picker errprs");
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabelWidget(field),
                      IconButton(
                        onPressed: picker.showPicker,
                        icon: Row(
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              color: hasError ? Get.theme.errorColor : null,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(dateToCustomString(picker.control.value).ctr),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (hasError)
                    Text(
                      (errorText ?? "").ctr,
                      style: TextStyle(color: Get.theme.errorColor),
                    )
                ],
              ),
            ),
          );
          ;
        },
        firstDate: start_date,
        lastDate: end_date,
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
    case FieldType.choice:
      var inputCont = Get.put(InputController(field: field), tag: field.name);

      reactiveInput = Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: LabelWidget(field),
              // Text(inputCont.isLoading.value ? 'Loading...' : labelName(field)),
            ),
            ReactiveDropdownField(
              hint: Text(
                  inputCont.isLoading.value ? "Loading...".ctr : "Select".ctr),
              formControlName: field.name,
              items: inputCont.choices?.value ?? [],
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
  final String name;
  late bool enableOfflineSave;
  MySubmitButton({
    super.key,
    required this.name,
    this.submitButtonText,
    this.submitButtonPreText,
    this.enableOfflineSave = false,
  }) {
    controller = Get.find<FormController>(tag: name);
  }

  @override
  Widget build(BuildContext context) {
    NetworkStatusController netCont = Get.find<NetworkStatusController>();

    var submitText = "${submitButtonPreText} ${submitButtonText}";
    return Obx(
      () => Column(
        children: [
          if (!netCont.isDeviceConnected.value)
            Text(
              "No internet connection".interpolate({}).ctr,
              style: Get.theme.textTheme.titleSmall
                  ?.copyWith(color: Get.theme.errorColor),
            ),
          if (netCont.isDeviceConnected.value || enableOfflineSave)
            ElevatedButton(
              onPressed: controller!.isLoading == true ? null : _onPressed,
              child: Text(controller!.isLoading == true
                  ? controller!.loadingMessage.ctr
                  : submitText),
            ),
        ],
      ),
    );
  }

  void _onPressed() {
    // controller.form
    final controller = Get.find<FormController>(tag: name);
    controller.submit();
  }
}
