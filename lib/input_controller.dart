library flutter_form;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'form_connect.dart';

class InputController extends GetxController {
  late FormItemField field;

  final FormController? formController;
  final Function? onSelectFirst;

  final FormGroup? form;

  var visible = true.obs;

  dynamic fromFieldValue = null;

  FormProvider formProvider = Get.find<FormProvider>();
  RxList<DropdownMenuItem> choices = RxList.empty();
  RxList<FormChoice> formChoices = RxList.empty();
  late String storageContainer;

  InputController({
    this.formController,
    this.storageContainer = "GetStorage",
    required this.field,
    this.form,
    this.onSelectFirst,
    this.fetchFirst = true,
  });
  Rx<FormChoice?> selected = Rx(null);

  var searchController = TextEditingController();

  final bool fetchFirst;

  var isLoading = false.obs;

  var noResults = "".obs;

  bool showOptions = false;
  Timer? _debounce;
  StreamSubscription? fromFieldSubscription;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setUpInputOptions();
  }

  @override
  void onClose() {
    super.onClose();
    fromFieldSubscription?.cancel();
  }

  handleFromField() {
    // dprint("Got a first from_field");
    fromFieldSubscription =
        form?.control(field.from_field!).valueChanges.listen((event) async {
      // dprint("Lister ${field.name} notified of ${field.from_field} changes");
      // dprint(event);
      await handleShowOnly(event);
    });
    handleShowOnly(form?.control(field.from_field!).value);
  }

  getFromFieldValue(dynamic fromFieldValue) async {
    dprint("Getting field value");
    if (field.show_only_field == null) {
      return fromFieldValue;
    }
    var jsonForm =
        formController?.formItems["actions"]["POST"] as Map<String, dynamic>;
    var fromField = FormItemField.fromJson(
        {"name": field.from_field, ...jsonForm[field.from_field]});
    var fullUrl =
        getFullInstanceUrl(fromField?.getInstanceUrl(), fromFieldValue);
    dprint(fullUrl);
    try {
      var instanceRes = await formProvider.formGet(fullUrl);
      // dprint(instanceRes.body);
      // dprint(instanceRes.statusCode);
      return instanceRes.body?[field.show_only_field];
    } catch (e) {
      dprint(e);
      return fromFieldValue;
    }

    return fromFieldValue;
  }

  handleShowOnly(dynamic value) async {
    // Handle getting the information
    fromFieldValue = await getFromFieldValue(value);

    if (field.show_only == null) {
      if (field.type != FieldType.multifield) {
        await getOptions();
      }
      return;
    }

    visible.value = false;
    var showOnlyValue = field.show_only;
    // dprint("Got $fromFieldValue making sure is $showOnlyValue");
    var show = showOnlyValue == fromFieldValue;
    // dprint("SHowing $show");
    if (!show) {
      if (form?.controls.containsKey(field.name) ?? false) {
        form?.removeControl(field.name);
      }
    } else {
      form?.addAll({field.name: getFormControl(field)});
    }
    visible.value = show;
    // Update options if show
    if (show) {
      if (field.type != FieldType.multifield) {
        await getOptions();
      }
    }
  }

  setUpInputOptions() {
    if (field.from_field != null) {
      handleFromField();
    } else if (this.fetchFirst) {
      this.getOptions();
    }
  }

  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // do something  with query
      // dprint("Searching for the stuff");
      // dprint(query);
      resetOptions();

      if (query != "") {
        getOptions(search: query);
      }
    });
  }

  selectValue(FormChoice? choice) {
    selected.value = choice;

    ///NOTE! Reset the controller before the options
    resetSearchController();
    resetOptions();
  }

  resetSearchController() {
    searchController.text = "";
  }

  resetOptions() {
    // dprint("resetting options");
    formChoices.value = [];
    choices.value = [];
    noResults.value = "";
  }

  getOptions({dynamic? search = null}) async {
    List<FormChoice>? rawChoices = [];
    Map<String, dynamic> queryParams = {};
    formChoices.value = [];

    if (search != null) {
      queryParams[field.search_field] = search;
    }

    if (fromFieldValue != null) {
      queryParams[field.from_field_value_field] = fromFieldValue;
    }

    // dprint(queryParams);
    if (field.choices != null) {
      dprint("GOt to the field choices");

      rawChoices = field.choices;
    } else if (field.storage != null) {
      final box = GetStorage(storageContainer);
      List<dynamic> rawItems = await box.read(field.storage ?? "") ?? [];
      // new Map<String, dynamic>.from(overview)
      List<dynamic> items = [];
      // queryParams[field.search_field] = search;

      if (fromFieldValue != null) {
        dprint(fromFieldValue);
        dprint(field.from_field_value_field);
        if (field.from_field_source != null) {
          if (field.search_field == "") {
            throw ("field.search_field not set");
          }
          if (rawItems.length > 0) {
            // dprint(rawItems);
            dprint("${field.from_field_source} $fromFieldValue");
            var sourceitem = rawItems.firstWhere((element) =>
                element[field.from_field_value_field]
                    .toString()
                    .toLowerCase() ==
                fromFieldValue.toString().toLowerCase());
            dprint(sourceitem);
            if (sourceitem != null) {
              items = sourceitem[field.from_field_source];
            }
          }
        } else if (field.from_field_value_field != null) {
          if (rawItems.length > 0) {
            dprint("DOing from field filterrin");
            dprint(rawItems.first);
            items = rawItems
                .where((element) =>
                    element[field.from_field_value_field]
                        .toString()
                        .toLowerCase() ==
                    fromFieldValue.toString().toLowerCase())
                .toList();

            dprint(field.name);
            dprint(items);
          } else {
            dprint("No raw items");
          }
        } else {
          items = rawItems;
        }
      } else {
        if (field.from_field == null) {
          items = rawItems;
        }
      }
      // dprint(field.storage);

      // dprint(field.name);
      // dprint(items);

      /// Perform search

      rawChoices = items
          .map((element) => new Map<dynamic, dynamic>.from(element))
          .map((choice) {
        var display_name =
            choice[field.display_name] ?? "${field.display_name} 404";
        var value_field =
            choice[field.value_field] ?? "${field.value_field} 404";
        return FormChoice(display_name: display_name, value: value_field);
      }).toList();

      // dprint(rawChoices);
    } else if (field.url != null) {
      try {
        isLoading.value = true;
        var choices = await formProvider.formGet(field.url, query: queryParams);
        isLoading.value = false;
        var urlChoices = [];
        // dprint(choices);
        // dprint("Getting status codfe ");
        // dprint(choices.statusCode);
        // dprint(choices.body);
        if (choices.statusCode == null) {
          dprint("NO internet conncetion");
          noResults.value = "No internet connection! Try again later!";
          return;
        }
        // dprint("Getting the options");
        if (choices.statusCode == 200) {
          if (choices?.body.runtimeType == String) {
            // dprint("FOnd strineg instrad");
            return;
          }
          if (choices.body.containsKey("results")) {
            urlChoices = choices.body["results"];
          } else if (choices.body.runtimeType == List) {
            urlChoices = choices.body;
          }
          // dprint("Url choicess");
          // dprint(urlChoices);
          // dprint(field.name);
          // dprint(field.display_name);
          // dprint(field.value_field);
          rawChoices = urlChoices
              .map(
                (choice) => FormChoice(
                    display_name: choice[field.display_name],
                    value: choice[field.value_field]),
              )
              .toList();
        } else {
          dprint("ad");
        }

        // dprint(choices.body);

      } catch (e) {
        if (e.runtimeType is HttpResponse) {
          dprint("Error a http response");
          var resp = e as HttpResponse;
          dprint(resp.statusCode);
        }
        noResults.value = "Failed, Try again later!.";
        dprint(e);
        isLoading.value = false;
      }
    }

    //Search
    dprint("Search $search ${field.url}");
    if (search != null && field.url == null) {
      rawChoices = rawChoices
          ?.where((FormChoice e) => e.display_name
              .toLowerCase()
              .contains(search.toString().toLowerCase()))
          .toList();
    }

    noResults.value =
        rawChoices != null && rawChoices!.isEmpty ? "No results." : "";

    // dprint(rawChoices!.map((e) => {e.display_name, e.value}));
    formChoices.value = rawChoices ?? [];
    choices.value = rawChoices!
        .map((e) => DropdownMenuItem(
              value: e.value,
              child: Text(e.display_name),
            ))
        .toList();

    // Seclt first woeks for FieldTye.field only
    // dprint("Checking to select first");
    // dprint(field.type);
    // dprint(field.select_first);
    if (field.type == FieldType.field && field.select_first) {
      // dprint(formChoices.value.length);
      if (formChoices.value.isNotEmpty) {
        // dprint("Selecting first");
        var first = formChoices.value.first;
        // dprint(first);
        // dprint(field.name);

        if (form != null) {
          // dprint("Form controller found");
          form?.control(field.name).patchValue(first.value);
          if (onSelectFirst != null) {
            onSelectFirst!(first);
          }
        } else {
          dprint("Form controller not found");
        }
      }
    }
    // dprint(choices.value);
  }
}
