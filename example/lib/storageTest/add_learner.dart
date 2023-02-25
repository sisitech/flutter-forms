import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';

import './options.dart';
import 'add_item_base.dart';

class AddLeaner extends StatelessWidget {
  static const routeName = "/add-leaner";
  const AddLeaner({super.key});

  @override
  Widget build(BuildContext context) {
    return AddItemBase(
      options: studentsOptions,
      title: Text("Leaner"),
      formTitle: 'addLeaner',
      submitButtonText: "Learner",
      isValidateOnly: true,
      url: "api/v1/students/",
      onSuccess: (value) {
        dprint("On SUccess");
        dprint(value);
        Get.back(result: value);
      },
      formGroupOrder: const [
        ['first_name'],
        // ['stream'],
        ['region'],
        ['district'],
        ['shehiya'],
        // ['middle_name'],
        // ['last_name'],
        // ['admission_no'],
        // ['status'],
        // ['gender'],
        // ['date_of_birth'],
        // ['date_enrolled'],
        // ['has_special_needs'],
        // ['special_needs'],
        // ['has_attended_pre_primary'],

        // ['street_name'],
        // ['house_number']
      ],
    );
  }
}
