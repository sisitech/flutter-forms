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
    if (field.choices != null) {
      choices.value = field.choices!
          .map((e) => DropdownMenuItem(
                value: e.value,
                child: Text(e.display_name),
              ))
          .toList();
    } else if (field.url != null) {
      try {
        isLoading.value = true;
        var choices = await formProvider.formGet(field.url);
        isLoading.value = false;

        if (choices.statusCode == 200) {}
        dprint(choices.body);
      } catch (e) {
        isLoading.value = false;
      }
    }
  }
}
