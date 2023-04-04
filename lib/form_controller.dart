library flutter_form;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_form/utils.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/network_status/network_status_controller.dart';
import 'package:flutter_utils/offline_http_cache/offline_http_cache.dart';
import 'package:flutter_utils/text_view/text_view_extensions.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'form_connect.dart';
import 'input_controller.dart';
import 'models.dart';

class FormController extends GetxController {
  final Map<String, dynamic> formItems;
  List<List<String>> formGroupOrder;
  final Map<String, dynamic>? extraFields;
  final bool isValidateOnly;
  final String? url;
  final String name;
  final String? instanceUrl;
  final ContentType contentType;
  final Function? handleErrors;
  final String loadingMessage;
  final Function(dynamic data)? onSuccess;
  final Function(dynamic data)? onOfflineSuccess;
  final Function? PreSaveData;
  final Function? getDynamicUrl;
  final Function? onFormItemTranform;
  final Function? onControllerSetup;
  final Function? getOfflineName;
  late bool displayRequiredFieldsOnValidate;

  var httpMethoFromStatus = {
    FormStatus.Add: "POST",
    FormStatus.Update: "PATCH",
    FormStatus.Replace: "PUT",
    FormStatus.Delete: "DELETE",
  };

  late bool enableOfflineMode;
  late bool? showOfflineMessage;
  late bool enableOfflineSave;

  RxList<String> requiredFieldNames = RxList();

  final Function(Map<String, dynamic>)? validateOfflineData;
  final Function(Map<String, dynamic>)? customDataValidation;

  final Map<String, dynamic>? instance;
  FormStatus status;
  final Function? onStatus;

  var isLoading = false.obs;
  var isInternetConnected = false.obs;
  FormProvider serv = Get.put<FormProvider>(FormProvider());
  NetworkStatusController netCont = Get.find<NetworkStatusController>();

  List<FormItemField> fields = [];
  RxList<String> errors = RxList();
  int? instanceId;
  late String storageContainer;
  late String offlineStorageContainer;
  StreamSubscription? subscription;

  FormController({
    required this.formItems,
    this.isValidateOnly = false,
    this.url,
    this.extraFields,
    required this.name,
    this.showOfflineMessage,
    this.enableOfflineMode = false,
    this.validateOfflineData,
    this.onSuccess,
    this.customDataValidation,
    this.displayRequiredFieldsOnValidate = false,
    this.getOfflineName,
    this.handleErrors,
    this.enableOfflineSave = false,
    this.onOfflineSuccess,
    this.getDynamicUrl,
    this.instance,
    this.onFormItemTranform,
    this.onStatus,
    this.instanceUrl,
    this.storageContainer = "GetStorage",
    this.offlineStorageContainer = "GetStorage",
    this.onControllerSetup,
    this.status = FormStatus.Add,
    this.PreSaveData,
    required this.loadingMessage,
    required this.contentType,
    this.formGroupOrder = const [],
  }) {
    // dprint(formItems);
    // dprint("Initialized this controller for me..");
  }

  @override
  void onInit() {
    super.onInit();
    setUpForm();
    internretStatusCheck();
  }

  @override
  void onClose() {
    subscription?.cancel();
    super.onClose();
  }

  internretStatusCheck() async {
    dprint("Network connection is ${netCont.isDeviceConnected}");
    subscription = netCont.isDeviceConnected.listen((value) {
      dprint("\n\n********\n\nInternet status $value");
    });
    dprint(
        "Network chckin.. connection is ${await netCont.checkIntenetConnection()}");
  }

  var form = FormGroup({});

  updateStatus(FormStatus Newstatus) {
    status = Newstatus;
    dprint("New status $status");
    if (onStatus != null) {
      onStatus!(Newstatus);
    }
  }

  setUpForm() {
    fields = [];
    dprint("Getting options");
    var jsonForm = formItems["actions"]["POST"] as Map<String, dynamic>;
    // dprint(jsonForm);
    var possibleFields = [];
    // dprint(formGroupOrder);
    formGroupOrder.forEach((row) {
      possibleFields.addAll(row);
    });
    dprint(possibleFields);
    possibleFields.forEach((value) {
      FormItemField field;
      //  = FormItemField.fromJson({"name": key, ...value});
      if (jsonForm.containsKey(value)) {
        field = FormItemField.fromJson({"name": value, ...jsonForm[value]});
      } else {
        field = FormItemField(
          name: value,
          label: value,
          type: FieldType.string,
        );
      }
      // If any Form Items transformations required
      if (onFormItemTranform != null) {
        field = onFormItemTranform!(field);
      }

      fields.add(field);
      form.addAll({
        value: getFormControl(field),
      });
      setupInputController(field);
    });

    if (this.instance != null) {
      this.instance?.forEach((key, value) {
        dprint("Instance found ");
        if (possibleFields.contains(key)) {
          // Updating a multified of an instance
          /**  instance{
             field type 'multified'
             ...
             multified: {
              "field":FormChoice(..)
             }
          
           }
          */
          var field = fields.firstWhere((field) => field.name == key);
          if (field != null && field.type == FieldType.multifield) {
            if (this.instance!.containsKey("multifield")) {
              var allMultiFields = this.instance!["multifield"];
              if (allMultiFields?.containsKey(key)) {
                var controller = Get.find<InputController>(tag: key);
                dprint("Updaint fields $key");
                dprint(allMultiFields[key]);
                // controller.selectedItems.value = allMultiFields[key];
                controller.updateChoices.value = allMultiFields[key];
              }
            }
          }
          if (field.type == FieldType.date ||
              field.type == FieldType.datetime) {
            dprint(value);
            if (value != null) {
              form.control(key).patchValue(DateTime.parse(value));
            }
          } else {
            form.control(key).patchValue(value);
          }
        }
        // this.form.updateValue(this.instance);
      });

      if (this.instance!.containsKey("id")) {
        this.instanceId = instance?["id"];
        if (status == FormStatus.Add) {
          updateStatus(FormStatus.Update);
        }
      }
    }

    update();
  }

  updateMultified(key, value) {}

  setupInputController(FormItemField field) {
    var requireControllerTypes = [
      FieldType.choice,
      FieldType.field,
      FieldType.multifield,
    ];

    if (requireControllerTypes.contains(field.type) ||
        field.from_field != null) {
      field.hasController = true;
      var inputCont = Get.put(
        InputController(
            field: field,
            formController: this,
            storageContainer: storageContainer,
            form: form,
            fetchFirst: field.type == FieldType.multifield ? false : true),
        tag: field.name,
      );
    }
  }

  getCurrentFormFields() {
    return {...form.value, ...extraFields ?? {}};
  }

  preparePostData() {
    var value = getCurrentFormFields();
    if (PreSaveData != null) {
      value = PreSaveData!(value);
    }
    return value;
  }

  validateDataOfflineMode() async {
    var value = getCurrentFormFields();
    if (validateOfflineData != null) {
      var res = validateOfflineData!(value);
      dprint("Validation is $res");
      return res;
    }
    return null;
  }

  validateUsingCustomValidation() async {
    var value = getCurrentFormFields();
    if (customDataValidation != null) {
      var res = customDataValidation!(value);
      dprint("Custom Validation is $res");
      return res;
    }
    return null;
  }

  getHandleCustomErrorsFuncntcion() {
    if (netCont.isDeviceConnected.value) {
      return handleErrors;
    }
    return null;
  }

  resolveRequestUrl(formData) {
    if (getDynamicUrl != null) {
      return getDynamicUrl!(formData);
    }
    return url;
  }

  updateFormErrors(Map<String, dynamic> formErrors,
      {handleCustomErrors = false}) {
    formErrors.forEach((key, value) {
      if (fields.map((e) => e.name).contains(key)) {
        String display = getErrorDisplay(value);
        form.control(key).setErrors({display: "error"});
      } else {
        String display = getErrorDisplay(value);
        if (handleErrors == null) {
          dprint("Adding error");
          errors.value.add(display);
        }
      }
    });

    Function? handleErrorFunc = getHandleCustomErrorsFuncntcion();

    if (handleErrorFunc != null) {
      dprint("HAndi;oingg..");
      String display = handleErrorFunc!(formErrors);
      errors.value.add(display);
    }
    form.markAllAsTouched();
  }

  submit() async {
    requiredFieldNames.value = [];
    if (!form.valid) {
      // dprint("Not valied");
      dprint(form.errors);
      try {
        requiredFieldNames.value = form.errors.keys
            .map((e) => fields.firstWhere((field) => field.name == e).label)
            .toList();
      } catch (e) {
        dprint(e);
      }

      dprint(requiredFieldNames);

      form.markAllAsTouched();

      return;
    }
    // dprint({url, isValidateOnly});
    // dprint(extraFields);

    errors.value = [];
    update();
    const successStatusCodes = [200, 201, 204];
    const errorStatusCodes = [400, 401, 403];

    // Pre Save Data
    var data = preparePostData();

    // Implement CustomVlidation
    if (customDataValidation != null) {
      var res = await validateUsingCustomValidation();
      dprint("Gto from custom validate");
      dprint(res);
      if (res != null) {
        updateFormErrors(res, handleCustomErrors: true);
        isLoading.value = false;
        return;
      }
    }

    // Offline mode support
    if (enableOfflineMode && !netCont.isDeviceConnected.value) {
      var res = await validateDataOfflineMode();
      dprint("Gto from offline validate");
      dprint(res);
      if (res != null) {
        updateFormErrors(res);
        isLoading.value = false;
        return;
      }
    }

    isLoading.value = true;

    var requrl = resolveRequestUrl(data);

    dprint(isValidateOnly);
    if (isValidateOnly) {
      if (onSuccess != null) {
        await onSuccess!(data);
      }
      isLoading.value = false;
      return;
    }

    // Confirm Internet connection before submitting
    if (!netCont.isDeviceConnected.value) {
      try {
        if (enableOfflineSave) {
          var offlineCont = Get.find<OfflineHttpCacheController>();
          if (status == FormStatus.Update || status == FormStatus.Replace) {
            requrl = getInstanceUrl();
            if (instanceId != null) {
              requrl = "$requrl/${instanceId}/".replaceAll("//", "/");
            }
          }
          String offlineName = name;
          if (getOfflineName != null) {
            offlineName = await getOfflineName!();
          }
          OfflineHttpCall offlineHttpCall = OfflineHttpCall(
              name: offlineName,
              httpMethod: httpMethoFromStatus[status] ?? "POST",
              urlPath: requrl,
              formData: data,
              storageContainer: offlineStorageContainer);
          offlineCont.saveOfflineCache(offlineHttpCall,
              taskPrefix: myform_work_manager_tasks_prefix);
          dprint("Saved offfline succeffully $storageContainer");
        } else {
          dprint("Offline save skipped `enableOfflineSave` DISABLED");
        }

        if (onOfflineSuccess != null) {
          await onOfflineSuccess!(data);
        }
      } catch (e) {
        isLoading.value = false;
        dprint("Failed to save offline");
        dprint(e);
      }
      isLoading.value = false;
      return;
    }
    try {
      dprint("Making api vcall");

      Response res;
      if (contentType == ContentType.form_url_encoded) {
        // dprint("Url encoded");
        res = await serv.formPostUrlEncoded(requrl, data);
      } else {
        dprint("None url encoded");
        if (status == FormStatus.Delete) {
          dprint(data);
          res = await serv.formDelete(requrl, query: data);
        } else if (status == FormStatus.Update ||
            status == FormStatus.Replace) {
          var updateUrl = "${getInstanceUrl()}";
          if (instanceId != null) {
            updateUrl = "$updateUrl/${instanceId}/".replaceAll("//", "/");
          }
          if (status == FormStatus.Replace) {
            res = await serv.formPut(updateUrl, data);
          } else {
            res = await serv.formPatch(updateUrl, data);
          }
        } else {
          res = await serv.formPost(requrl, data);
        }
      }
      dprint(res.statusCode);
      if (successStatusCodes.contains(res.statusCode)) {
        if (onSuccess != null) {
          await onSuccess!(res.body);
        }
      } else if (errorStatusCodes.contains(res.statusCode)) {
        dprint(res.body);
        try {
          // dprint("Done with call");
          var formErrors = res.body as Map<String, dynamic>;
          // dprint(formErrors);
          updateFormErrors(formErrors, handleCustomErrors: true);
        } catch (e) {
          dprint(e);
        }
      }
      isLoading.value = false;
    } catch (e) {
      dprint("Error clals");
      isLoading.value = false;
      dprint(e);
    }

    update();
  }

  getInstanceUrl() {
    if (instanceUrl != null) {
      return this.instanceUrl?.toUrlNoSlash();
    }
    return this.url?.toUrlNoSlash();
  }

  getErrorDisplay(dynamic value) {
    String display = "";
    if (value.runtimeType == List<dynamic>) {
      display = value.join("\n");
    } else {
      display = value;
    }
    return display;
  }
}
