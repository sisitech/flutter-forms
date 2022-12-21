library flutter_form;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import 'form_connect.dart';

class InputController extends GetxController {
  late FormItemField field;
  FormProvider formProvider = Get.find<FormProvider>();
  RxList<DropdownMenuItem> choices = RxList.empty();
  RxList<FormChoice> formChoices = RxList.empty();

  InputController({required this.field, this.fetchFirst = true});
  Rx<FormChoice?> selected = Rx(null);

  var searchController = TextEditingController();

  final bool fetchFirst;

  var isLoading = false.obs;

  var noResults = "".obs;

  bool showOptions = false;
  Timer? _debounce;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (this.fetchFirst) {
      this.getOptions();
    }
  }

  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // do something  with query
      dprint("Searching for the stuff");
      dprint(query);
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
    dprint("resetting options");
    formChoices.value = [];
    choices.value = [];
    noResults.value = "";
  }

  getOptions({String? search}) async {
    List<FormChoice>? rawChoices = [];
    Map<String, dynamic> queryParams = {};
    formChoices.value = [];

    if (search != null) {
      queryParams[field.search_field] = search;
    }
    // dprint(queryParams);

    if (field.choices != null) {
      rawChoices = field.choices;
    } else if (field.url != null) {
      try {
        isLoading.value = true;
        var choices = await formProvider.formGet(field.url, query: queryParams);
        isLoading.value = false;
        var urlChoices = [];
        dprint(choices);
        dprint(choices.statusCode);
        if (choices.statusCode == null) {
          dprint("NO internet conncetion");
          noResults.value = "Failed, Try again later!.";
          return;
        }

        if (choices.statusCode == 200) {
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
        }
        noResults.value =
            rawChoices != null && rawChoices!.isEmpty ? "No results." : "";
        dprint(choices.body);
      } catch (e) {
        noResults.value = "Failed, Try again later!.";
        dprint(e);
        isLoading.value = false;
      }
    }

    // dprint(rawChoices!.map((e) => {e.display_name, e.value}));
    formChoices.value = rawChoices ?? [];
    choices.value = rawChoices!
        .map((e) => DropdownMenuItem(
              value: e.value,
              child: Text(e.display_name),
            ))
        .toList();

    // dprint(choices.value);
  }
}
