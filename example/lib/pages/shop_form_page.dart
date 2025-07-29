import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';

import '../shop_options.dart';
import '../widgets/app_drawer.dart';

class ShopFormPage extends StatelessWidget {
  const ShopFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    FormController? controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Shop"),
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
                child: MyCustomForm(
                  name: "ShopForm",
                  formItems: shopOptions,
                  formTitle: "Shop Information",
                  url: "api/v1/shops/",
                  contentType: ContentType.json,
                  enableOfflineMode: true,
                  enableOfflineSave: true,
                  onControllerSetup: (contr) => controller = contr,
                  onSuccess: (value) {
                    dprint("Shop created successfully:");
                    dprint(value);

                    // Show success message
                    Get.snackbar(
                      "Success",
                      "Shop created successfully!",
                      backgroundColor: Colors.green.withOpacity(0.8),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );

                    // Clear form after successful submission
                    if (controller != null) {
                      controller!.form.reset();
                    }
                  },
                  onOfflineSuccess: (value) {
                    dprint("Shop saved offline:");
                    dprint(value);

                    Get.snackbar(
                      "Saved Offline",
                      "Shop saved offline and will sync when connected",
                      backgroundColor: Colors.orange.withOpacity(0.8),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  handleErrors: (errors) {
                    dprint("Shop creation errors:");
                    dprint(errors);
                    return "Failed to create shop. Please check your inputs.";
                  },
                  formGroupOrder: const [
                    ['name'],
                    ['description'],
                    ['location'],
                    ['support_email', 'support_phone'],
                    ['image'],
                    ['banner_image'],
                    ['menu_file'],
                    ['user']
                  ],
                  submitButtonText: "Create Shop",
                  formFooter: const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "All fields with * are required",
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
