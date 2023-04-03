import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:form_example/storageTest/options.dart';
import 'package:get/get.dart';

class AddItemBase extends StatelessWidget {
  final dynamic options;
  Widget title;
  String formTitle;
  String? url;
  String? submitButtonText;
  List<List<String>> formGroupOrder;

  Function(dynamic value)? onSuccess;
  Map<String, dynamic>? extraFields;
  bool isValidateOnly;

  AddItemBase({
    super.key,
    required this.options,
    required this.title,
    this.submitButtonText,
    this.url,
    this.extraFields,
    this.formGroupOrder = const [],
    this.isValidateOnly = false,
    required this.formTitle,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    var instance = studInstance; // Get.arguments?["instance"];
    dprint(instance);
    return Scaffold(
      appBar: AppBar(title: title),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: MyCustomForm(
                storageContainer: 'school',
                formItems: options,
                onStatus: (FormStatus status) {},
                instance: instance,
                contentType: ContentType.json,
                // formHeader: Text("Welcome home"),
                url: url, //"api/v1/students/",
                // onSuccess: (value) {
                //   dprint("On SUccess");
                //   dprint(value);
                //   Get.back(result: value);
                // },
                onSuccess: onSuccess,
                // submitButtonPreText: submitButtonPreText,
                submitButtonText: submitButtonText ?? formTitle,
                // extraFields: const {"active": true},
                extraFields: extraFields,
                isValidateOnly: isValidateOnly,
                formGroupOrder: formGroupOrder,
                formTitle: formTitle, name: formTitle,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
