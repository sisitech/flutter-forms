library flutter_form;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:flutter_form/multiselect/multiselect_theme.dart';
import 'package:flutter_form/utils.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
import 'package:flutter_utils/network_status/network_status_controller.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:flutter_utils/extensions/date_extensions.dart';
import 'input_controller.dart';
import 'models.dart';
import 'multiselect/multiselect.dart';
import 'utils.dart';
import 'file_picker_widget.dart';
import 'image_picker_widget.dart';

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
  final Widget? formPreFooter;
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
  late bool showOfflineMessage;
  late Color? offlineMessageColor;
  final String? offlineMessage;
  late bool displayRequiredFieldsOnValidate;
  final String loadingMessage;
  FormStatus status;
  final Map<String, dynamic>? instance;
  final String? url;
  final List<List<String>> formGroupOrder;
  final Map<String, dynamic>? extraFields;
  TextStyle? formTitleStyle;
  final String? instanceUrl;

  final Function(Map<String, dynamic>)? customDataValidation;
  final Function(Map<String, dynamic>)? validateOfflineData;
  final Function? onStatus;
  final Function? getDynamicUrl;
  final Function(dynamic data)? getOfflineName;
  final Widget? customChild;
  final List<String>? customFields;

  MyCustomForm({
    super.key,
    this.formTitle,
    this.formItems = defaultOptions,
    this.formGroupOrder = const [],
    this.formHeader,
    this.offlineMessage,
    this.enableOfflineMode = false,
    this.offlineMessageColor,
    this.enableOfflineSave = false,
    this.validateOfflineData,
    this.customDataValidation,
    this.displayRequiredFieldsOnValidate = true,
    this.formFooter,
    this.formPreFooter,
    this.formTitleStyle,
    this.extraFields,
    this.isValidateOnly = false,
    this.showOfflineMessage = false,
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
    this.customChild,
    this.customFields,
  }) : assert(
    customFields == null || formGroupOrder.isEmpty,
    'customFields and formGroupOrder cannot both be provided'
  ), assert(
    customChild == null || customFields != null,
    'customFields is required when using customChild'
  ) {
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
          displayRequiredFieldsOnValidate: displayRequiredFieldsOnValidate,
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
          customFields: customFields,
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
          // If customChild provided, use minimal ReactiveForm wrapper
          if (customChild != null) {
            return ReactiveForm(
              formGroup: controller.form,
              child: customChild!,
            );
          }

          // Default auto-generated form layout
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
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        if (controller.errors.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.errors.value.length,
                            itemBuilder: (context, index) {
                              return Text(
                                controller.errors.value[index].ctr,
                                style: TextStyle(
                                    color: Get.theme.colorScheme.error),
                              );
                            },
                          ),
                      ],
                    ),
                  );
                }),
                Obx(() {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (controller.requiredFieldNames.value.isNotEmpty)
                        Column(
                          children: [
                            Text(
                              "Please correct the following fields".ctr,
                              style:
                                  TextStyle(color: Get.theme.colorScheme.error),
                            ),
                            Text(
                              controller.requiredFieldsMessage,
                              style:
                                  TextStyle(color: Get.theme.colorScheme.error),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                    ],
                  );
                }),
                if (controller.errors.isNotEmpty)
                  const SizedBox(
                    height: 10,
                  ),
                if (formPreFooter != null) ...[
                  formPreFooter!,
                  const SizedBox(
                    height: 10,
                  ),
                ],
                MySubmitButton(
                  name: name,
                  showNoInternectConnectionMessage: showOfflineMessage,
                  enableOfflineSave: enableOfflineMode,
                  offlineMessageColor: offlineMessageColor,
                  offlineMessage: offlineMessage,
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
    padding: const EdgeInsets.only(top: 0, bottom: 0),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: getInputBasedOnType(field),
    ),
  );
}

labelName(field) => "${field.label}".ctr + " ${field.required ? '*' : ''}";

inputDecoration(field) => InputDecoration(
      labelText: labelName(field),
      helperText: "${field.placeholder ?? ''}".ctr,
      counterText: "",
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );

Widget LabelWidget(FormItemField field) {
  return Text(
    labelName(field),
    style: Get.theme.inputDecorationTheme.labelStyle,
  );
}

Widget MultifieldLabelWidget(FormItemField field, BuildContext context) {
  var multiselectTheme =
      Theme.of(context).extension<SisitechMultiSelectTheme>();
  return Align(
    alignment: Alignment.topLeft,
    child: Text(
      labelName(field),
      style: Get.textTheme.bodyLarge?.copyWith(
        color: multiselectTheme?.labelColor,
      ),
    ),
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
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
          ],
          decoration: inputDecoration(field));
      break;

    case FieldType.float:
      reactiveInput = ReactiveTextField<double>(
          formControlName: field.name,
          valueAccessor: DoubleValueAccessor(),
          validationMessages: defaultValidationMessage,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
          ],
          decoration: inputDecoration(field));
      break;
    case FieldType.integer:
      reactiveInput = ReactiveTextField<int>(
          formControlName: field.name,
          valueAccessor: IntValueAccessor(),
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
        decoration: inputDecoration(field),
      );
      break;
    case FieldType.boolean:
      var inputCont = Get.find<InputController>(tag: field.name);
      FormControl<bool> formControl =
          inputCont.form?.control(field.name) as FormControl<bool>;

      reactiveInput = Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            formControl.updateValue(!(formControl.value ?? false));
            formControl.focus();
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: kFormFieldSpacing),
            child: StreamBuilder<bool>(
              stream: formControl.focusChanges,
              builder: (context, snapshot) {
                final isFocused = formControl.hasFocus;
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: getThemedContainerDecoration(context, isFocused: isFocused),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabelWidget(field),
                      ReactiveCheckbox(
                        onChanged: (value) {
                          formControl.focus();
                        },
                        formControlName: field.name,
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
      break;
    case FieldType.date:
      reactiveInput = ReactiveDateTimePicker(
        formControlName: field.name,
        type: ReactiveDatePickerFieldType.date,
        firstDate: start_date,
        lastDate: end_date,
        decoration: inputDecoration(field).copyWith(
          suffixIcon: const Icon(Icons.date_range_outlined),
        ),
      );
      break;
    case FieldType.time:
      reactiveInput = ReactiveDateTimePicker(
        formControlName: field.name,
        type: ReactiveDatePickerFieldType.time,
        firstDate: start_date,
        lastDate: end_date,
        decoration: inputDecoration(field).copyWith(
          suffixIcon: const Icon(Icons.access_time),
        ),
      );
      break;
    case FieldType.datetime:
      reactiveInput = ReactiveDateTimePicker(
        formControlName: field.name,
        type: ReactiveDatePickerFieldType.dateTime,
        firstDate: start_date,
        lastDate: end_date,
        decoration: inputDecoration(field).copyWith(
          suffixIcon: const Icon(Icons.calendar_today),
        ),
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
              decoration: const InputDecoration(),
            ),
            const SizedBox(
              height: kFormFieldSpacing,
            ),
          ],
        ),
      );
      break;
    case FieldType.file:
      var fileInputCont = Get.find<InputController>(tag: field.name);
      reactiveInput = FilePickerWidget(
        formControlName: field.name,
        field: field,
      );
      break;
    case FieldType.image:
      var imageInputCont = Get.find<InputController>(tag: field.name);
      reactiveInput = ImagePickerWidget(
        formControlName: field.name,
        field: field,
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
  final String? submitButtonText;
  final String? submitButtonPreText;
  final String? offlineMessage;
  final String name;
  final bool enableOfflineSave;
  final Color? offlineMessageColor;
  final bool showNoInternectConnectionMessage;
  const MySubmitButton({
    super.key,
    required this.name,
    this.submitButtonText,
    this.submitButtonPreText,
    this.showNoInternectConnectionMessage = true,
    this.offlineMessage,
    this.offlineMessageColor,
    this.enableOfflineSave = false,
  });

  @override
  Widget build(BuildContext context) {
    FormController controller = Get.find<FormController>(tag: name);
    NetworkStatusController netCont = Get.find<NetworkStatusController>();

    String finalOfflineMessage = offlineMessage ?? "No internet connection".ctr;
    var finalMessageColor =
        offlineMessageColor ?? Theme.of(context).colorScheme.error;

    var submitText = "${submitButtonPreText ?? ''} ${submitButtonText ?? ''}";
    return Obx(
      () => Column(
        children: [
          if (!netCont.isDeviceConnected.value &&
              showNoInternectConnectionMessage)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                finalOfflineMessage,
                style: Get.theme.textTheme.titleSmall
                    ?.copyWith(color: finalMessageColor),
              ),
            ),
          if (netCont.isDeviceConnected.value || enableOfflineSave)
            ElevatedButton(
              onPressed: controller.isLoading.value ? null : _onPressed,
              child: controller.isLoading.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).disabledColor),
                      ),
                    )
                  : Text(
                      submitText.ctr,
                    ),
            ),
        ],
      ),
    );
  }

  void _onPressed() {
    final controller = Get.find<FormController>(tag: name);
    controller.form.unfocus();
    controller.submit();
  }
}
