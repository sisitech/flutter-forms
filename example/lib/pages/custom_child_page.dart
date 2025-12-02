import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../teacher_options.dart';
import '../widgets/app_drawer.dart';

class CustomChildPage extends StatelessWidget {
  const CustomChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Child Form"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Custom Child Example",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This form uses customChild and customFields to manually layout fields. It's set to validateOnly mode (no server submission).",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: MyCustomForm(
                name: 'customChildForm',
                formItems: teacherOptions,
                isValidateOnly: true,
                customFields: ['first_name', 'email'],
                PreSaveData: (data) {
                  data["detail"] = "WHI AM I";
                  return data;
                },
                customChild: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text("data"),
                      ReactiveTextField<String>(
                        formControlName: 'first_name',
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          hintText: 'Enter your first name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ReactiveTextField<String>(
                        formControlName: 'email',
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final ctrl =
                              Get.find<FormController>(tag: 'customChildForm');
                          ctrl.submit();
                        },
                        child: const Text('Validate Form'),
                      ),
                    ],
                  ),
                ),
                onSuccess: (res) {
                  dprint("Custom child form validated: $res");
                  Get.snackbar(
                    "Success",
                    "Form validated successfully!",
                    backgroundColor: Colors.green.withValues(alpha: 0.8),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
