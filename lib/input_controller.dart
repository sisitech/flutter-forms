library flutter_form;

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
  InputController({required this.field});

  var isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    this.getOptions();
  }

  getOptions() async {
    List<FormChoice>? rawChoices = [];

    if (field.choices != null) {
      rawChoices = field.choices;
    } else if (field.url != null) {
      try {
        isLoading.value = true;
        var choices = await formProvider.formGet(field.url);
        isLoading.value = false;
        var urlChoices = [];

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
        // dprint(choices.body);
      } catch (e) {
        dprint(e);
        isLoading.value = false;
      }
    }
    // dprint(rawChoices!.map((e) => {e.display_name, e.value}));
    choices.value = rawChoices!
        .map((e) => DropdownMenuItem(
              value: e.value,
              child: Text(e.display_name),
            ))
        .toList();

    // dprint(choices.value);
  }
}
