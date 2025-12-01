import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/network_status/network_status_controller.dart';
import 'package:get/get.dart';

import '../main_controller.dart';
import '../teacher_options.dart';

class MainForm extends StatelessWidget {
  MainForm({super.key});

  FormController? controller;

  var isFormVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    AuthController authCont = Get.find<AuthController>();

    MyMainController mainCont = Get.find<MyMainController>();
    NetworkStatusController netCont = Get.find<NetworkStatusController>();
    isFormVisible.value = true;
    return Obx(() {
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              isFormVisible.value = true;
            },
            label: Text("Show Form"),
          ),
          if (isFormVisible.value)
            MyCustomForm(
              name: "Hello",
              formItems: teacherOptions,
              // onFormItemTranform: (FormItemField field) {
              //   if (field.name == "contact_name") {
              //     field.label = "${field.label} Transformed";
              //   }
              //   return field;
              // },

              url: "api/v1/teachers",
              enableOfflineMode: true,
              enableOfflineSave: true,
              onControllerSetup: (contr) => controller = contr,
              instance: false
                  ? null
                  : {
                      "contact_email": "michameiu@gmail.com",
                      "id": 34,
                      "role": 1,
                      // "modified": "2023-03-04",
                      "contact_phone": "2323aba989dad",
                      // "tsc_no": "A3B4",
                      "phone": const ["121", "12", "13", "14"],
                      "multifield": {
                        "phone": [
                          FormChoice(
                            display_name: "Ler 11  District 1",
                            value: "12",
                          ),
                          FormChoice(
                            display_name: "Ler 12 -District 1",
                            value: "121",
                          ),
                          FormChoice(
                            display_name: "Ler 13  District 1",
                            value: "13",
                          ),
                          FormChoice(
                            display_name: "Ler 14  District 1",
                            value: "14",
                          ),
                        ],
                        "role": [
                          FormChoice(
                            display_name: "District 11",
                            value: "1",
                          ),
                        ],
                      }
                    },
              // storageContainer: "school",
              PreSaveData: (formData) {
                dprint(formData);
                return formData;
              },
              // status: FormStatus.Update,
              contentType: ContentType.json,
              // formHeader: const Text("Welcome home"),
              onSuccess: (value) {
                dprint(value);
                dprint(value["modified"].runtimeType);
                if (controller != null) {
                  var controlName = "modified";
                  controller?.form
                      .control(controlName)
                      .setErrors({"Faield..": ""});
                  controller?.form.control(controlName).markAsTouched();
                }
              },
              // handleErrors: (value) {
              //   return "Textsitn new validation";
              // },
              // isValidateOnly: true,
              formGroupOrder: const [
                // ['role'],
                ["created"],
                ["appointment_datetime"],
                ["preferred_time"],
                ["category"],
                ['subcategory'],
                ['receipt'],
                ['attachment'],
                ['active'],
                ['first_name'],
                ['tag_rule_type'],
                // ["phone"],
                // ["active"],

                // ["modified"],
                // ["contact_name"],
                // ["contact_phone"],
                // ["tsc_no"],
                // ["location"]
              ],
              formTitle: "Login Teacher",
              formFooter: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text("Sign Up"),
              ),
            ),
        ],
      );
    });
  }
}
