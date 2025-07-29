import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';

import '../shop_options.dart';
import '../widgets/app_drawer.dart';

class ShopFormController extends GetxController {
  var isUpdateMode = false.obs;
  var toggleCounter = 0.obs;

  void toggleMode() {
    isUpdateMode.value = !isUpdateMode.value;
    toggleCounter.value++;
    
    // Clean up the old form controller
    String oldFormName = isUpdateMode.value ? "ShopFormCreate" : "ShopFormUpdate";
    try {
      Get.delete<FormController>(tag: oldFormName);
    } catch (e) {
      // Controller might not exist yet, ignore
    }
  }
}

const shopInstance = {
  "id": 11,
  "image":
      "https://api.expensetracker.wavvy.dev/media/Images/2025/July/29/ac1e1cca-66c5-4153-841a-bbc71eb66ad8.jpg",
  "cache_image":
      "https://api.expensetracker.wavvy.dev/media/CACHE/images/Images/2025/July/29/ac1e1cca-66c5-4153-841a-bbc71eb66ad8/e748d45948f9945d21217911fef111d0.jpg",
  "avatar_image":
      "https://api.expensetracker.wavvy.dev/media/CACHE/images/Images/2025/July/29/ac1e1cca-66c5-4153-841a-bbc71eb66ad8/d7d11c893a285b4b1c634a5b21c6de10.jpg",
  "banner_image":
      "https://api.expensetracker.wavvy.dev/media/Images/2025/July/29/7efe20a3-f2e1-4055-bb25-0c7d44b1c546.jpg",
  "banner_cache_image":
      "https://api.expensetracker.wavvy.dev/media/CACHE/images/Images/2025/July/29/7efe20a3-f2e1-4055-bb25-0c7d44b1c546/43f1d3df6781c6e6fcadc6bc9e70ed8e.jpg",
  "banner_avatar_image":
      "https://api.expensetracker.wavvy.dev/media/CACHE/images/Images/2025/July/29/7efe20a3-f2e1-4055-bb25-0c7d44b1c546/75b183864f88214d3222ce3ece115328.jpg",
  "created": "2025-07-29T10:58:47.029840+03:00",
  "modified": "2025-07-29T10:58:47.029877+03:00",
  "name": "Test",
  "description": null,
  "location": null,
  "support_email": null,
  "support_phone": null,
  "created_by": null,
  "updated_by": null,
  "user": 1
};

class ShopFormPage extends StatelessWidget {
  const ShopFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shopController = Get.put(ShopFormController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(shopController.isUpdateMode.value ? "Update Shop" : "Create Shop")),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Button Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() => Row(
                  children: [
                    Icon(
                      shopController.isUpdateMode.value ? Icons.edit : Icons.add,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        shopController.isUpdateMode.value 
                          ? "Update Mode: Editing existing shop" 
                          : "Create Mode: Adding new shop",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Switch(
                      value: shopController.isUpdateMode.value,
                      onChanged: (_) => shopController.toggleMode(),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ],
                )),
              ),
            ),
            const SizedBox(height: 16),
            
            // Form Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() => MyCustomForm(
                  key: ValueKey("${shopController.isUpdateMode.value}_${shopController.toggleCounter.value}"), // Force rebuild when mode changes
                  name: shopController.isUpdateMode.value ? "ShopFormUpdate" : "ShopFormCreate",
                  formItems: shopOptions,
                  formTitle: "Shop Information",
                  url: "api/v1/shops/",
                  contentType: ContentType.json,
                  enableOfflineMode: true,
                  enableOfflineSave: true,
                  instance: shopController.isUpdateMode.value ? shopInstance : null,
                  onControllerSetup: (contr) {
                    // Form controller is set up automatically
                  },
                  onSuccess: (value) {
                    dprint(shopController.isUpdateMode.value 
                      ? "Shop updated successfully:" 
                      : "Shop created successfully:");
                    dprint(value);

                    // Show success message
                    Get.snackbar(
                      "Success",
                      shopController.isUpdateMode.value 
                        ? "Shop updated successfully!" 
                        : "Shop created successfully!",
                      backgroundColor: Colors.green.withValues(alpha: 0.8),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );

                    // Form handles its own state after successful submission
                  },
                  onOfflineSuccess: (value) {
                    dprint(shopController.isUpdateMode.value 
                      ? "Shop update saved offline:" 
                      : "Shop creation saved offline:");
                    dprint(value);

                    Get.snackbar(
                      "Saved Offline",
                      shopController.isUpdateMode.value 
                        ? "Shop update saved offline and will sync when connected"
                        : "Shop creation saved offline and will sync when connected",
                      backgroundColor: Colors.orange.withValues(alpha: 0.8),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  handleErrors: (errors) {
                    dprint(shopController.isUpdateMode.value 
                      ? "Shop update errors:" 
                      : "Shop creation errors:");
                    dprint(errors);
                    return shopController.isUpdateMode.value 
                      ? "Failed to update shop. Please check your inputs."
                      : "Failed to create shop. Please check your inputs.";
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
                  submitButtonText: "Shop",
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
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
