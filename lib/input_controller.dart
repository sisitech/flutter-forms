library flutter_form;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/internalization/extensions.dart';
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
  RxList<FormChoice> updateChoices = RxList.empty();
  late String storageContainer;

  InputController({
    this.formController,
    this.storageContainer = "GetStorage",
    required this.field,
    this.form,
    this.onSelectFirst,
    this.fetchFirst = true,
  });
  RxList<FormChoice> selectedItems = RxList.empty();

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
      dprint("From field changed to $event");
      fromFieldValue = event;
      // try {
      //   form?.control(field.name).reset();
      // } catch (e) {}
      await handleShowOnly();
    });
    fromFieldValue = form?.control(field.from_field!).value;

    // Prevent fetch_first multifields from gettting info first time
    // Unless its a show only field
    if (!field.fetch_first) {
      handleShowOnly();
    }
  }

  getFromFieldValue() async {
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
      return instanceRes.body?[field.show_only_field];
    } catch (e) {
      dprint(e);
      return fromFieldValue;
    }
  }

  handleShowOnly() async {
    // Handle getting the information
    visible.value = field.show_only == null;

    var parsedFromFieldValue = await getFromFieldValue();

    dprint("Parsed from field $parsedFromFieldValue");
    if (field.show_only == null) {
      if (field.type != FieldType.multifield || field.fetch_first) {
        await getOptions();
      }
      return;
    }
    dprint("Show only enbled");

    if (field.fetch_first) {
      await getOptions();
    }

    var showOnlyValue = field.show_only;

    dprint("Got $parsedFromFieldValue making sure is $showOnlyValue");
    var show = showOnlyValue.toString() == parsedFromFieldValue.toString();
    dprint("SHowing $show");
    if (!show) {
      if (form?.controls.containsKey(field.name) ?? false) {
        dprint("Removing control ${field.name}");
        form?.removeControl(field.name);
      }
    } else {
      var fieldControl = getFormControl(field);
      form?.addAll({field.name: fieldControl});
      dprint("Adding control ${field.name}");
      dprint(fieldControl.value);
      //Update if any data available
      if (formController?.instance != null) {
        dprint("Updaint values possible");
        var instance = formController?.instance;
        if (instance?.containsKey(field.name) ?? false) {
          var value = instance?[field.name];
          fieldControl.patchValue(value);
        }
      }
      dprint("After patch ${fieldControl.value}");
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

  selectValue(List<FormChoice> choices) {
    // dprint("Selecting Value input contr");
    selectedItems.value = choices;

    ///NOTE! Reset the controller before the options
    resetSearchController();
    resetOptions();
  }

  resetSearchController() {
    searchController.text = "";
  }

  cancelNoResults() {
    noResults.value = "";
    resetSearchController();
  }

  resetOptions() {
    // dprint("resetting options");
    if (!field.fetch_first) {
      formChoices.value = [];
      choices.value = [];
    }
    noResults.value = "";
  }

  List<FormChoice> getAllPosibleOptions() {
    return [
      ...formChoices.value,
      ...selectedItems.value,
      ...updateChoices.value
    ];
  }

  FormChoice getChoice(dynamic id) {
    var possibleChoices = getAllPosibleOptions();
    var itemQuery = possibleChoices
        .where((element) => element.value.toString() == id.toString());
    if (itemQuery.isNotEmpty) {
      return itemQuery.first;
    } else {
      return FormChoice(display_name: "Choice $id", value: id);
    }
  }

  getOptions({dynamic? search = null}) async {
    if (field.from_field != null) {
      // dprint("From field enbled..");
    }
    dprint(field.from_field);
    List<FormChoice>? rawChoices = [];
    Map<String, dynamic> queryParams = {};
    formChoices.value = [];

    if (search != null) {
      queryParams[field.search_field] = search.toString();
    }

    if (fromFieldValue != null &&
        (field.from_field_value_field?.isNotEmpty ?? false)) {
      queryParams[field.from_field_value_field!] = "$fromFieldValue";
    }

    if (field.type == FieldType.multifield) {
      if (!field.fetch_first) {
        queryParams["page_size"] = "4";
      }
    }

    // dprint(queryParams);
    if (field.choices != null) {
      // dprint("GOt to the field choices");

      rawChoices = field.choices?.map((e) {
        e.display_name = "${e.display_name}".ctr;
        return e;
      }).toList();
    } else if (field.storage != null) {
      final box = GetStorage(storageContainer);
      dprint("THE OFFLINE KEYS ARES container $storageContainer");
      dprint(box.getKeys());
      var rawItemsDynamic = await box.read(field.storage ?? "");
      List<dynamic> rawItems = [];
      if (rawItemsDynamic is List<dynamic>) {
        dprint("The items are a dynamiiiiiiic.");

        rawItems = rawItemsDynamic;
      } else if (rawItemsDynamic is String && rawItemsDynamic.isNotEmpty) {
        dprint("The items are a striiiiing.");
        // If you expected a list, perhaps deserialize it
        try {
          rawItems = jsonDecode(rawItemsDynamic);
        } catch (e) {
          dprint(e);
          dprint(rawItemsDynamic);
        }
      }

      dprint("FOind ${rawItems.length} for ${field.name}");
      // new Map<String, dynamic>.from(overview)
      List<dynamic> items = [];
      // queryParams[field.search_field] = search;

      if (field.from_field != null) {
        // dprint(fromFieldValue);
        // dprint(field.from_field_value_field);
        if (field.from_field_source?.isNotEmpty ?? false) {
          if (field.search_field == "") {
            throw ("field.search_field not set");
          }
          if (rawItems.length > 0) {
            // dprint(rawItems.first);
            // dprint("${field.from_field_source} $fromFieldValue");
            var sourceitem = rawItems.firstWhere((element) =>
                element[field.from_field_value_field]
                    .toString()
                    .toLowerCase() ==
                fromFieldValue.toString().toLowerCase());
            // dprint(sourceitem);
            if (sourceitem != null) {
              items = sourceitem[field.from_field_source];
            }
          }
        } else if (field.from_field_value_field?.isNotEmpty ?? false) {
          if (rawItems.length > 0) {
            // dprint(
            //     "DOing filtering of  from_field_value_field ${field.from_field_value_field}");
            // dprint(rawItems.first);
            items = rawItems
                .where((element) =>
                    element[field.from_field_value_field]
                        .toString()
                        .toLowerCase() ==
                    fromFieldValue.toString().toLowerCase())
                .toList();

            // dprint(field.name);
            // dprint(items);
          } else {
            dprint("No raw items");
          }
        } else {
          dprint("Just a show only field");
          items = rawItems;
        }
      } else {
        dprint("No from_field field");

        items = rawItems;
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
        return FormChoice(
            display_name: "$display_name".ctr, value: value_field);
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
                    display_name: "${choice[field.display_name]}".ctr,
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
    // dprint("Search $search ${field.url}");
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

    // selected.value = null;
    // selected.value = null;

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
