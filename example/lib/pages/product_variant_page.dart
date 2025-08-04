import 'package:flutter/material.dart';
import 'package:flutter_form/flutter_form.dart';
import 'package:flutter_form/form_controller.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:get/get.dart';

import '../product_variant_options.dart';
import '../widgets/app_drawer.dart';

class ProductVariantController extends GetxController {
  var isUpdateMode = false.obs;
  var toggleCounter = 0.obs;

  void toggleMode() {
    isUpdateMode.value = !isUpdateMode.value;
    toggleCounter.value++;

    String oldFormName =
        isUpdateMode.value ? "ProductVariantFormCreate" : "ProductVariantFormUpdate";
    try {
      Get.delete<FormController>(tag: oldFormName);
    } catch (e) {
      // Controller might not exist yet, ignore
    }
  }
}

const productVariantInstance = {
  "id": 1,
  "image": null,
  "cache_image": null,
  "avatar_image": null,
  "product_name": "Sisitech Hoodie",
  "category_name": "Merchandise",
  "sub_category_name": "Top Drip",
  "product_description": "Comfort meets purpose in the official Sisitech Hoodie. With a clean design and bold logo, it's perfect for innovators on the move. Soft, durable, and made for everyday wear — rep the mission in style.\r\n\r\n⭐ Unisex fit\r\n⭐ Soft cotton-poly blend\r\n⭐ Front pocket\r\n⭐ Machine washable\r\n\r\nWear the vision.",
  "is_low_stock": true,
  "attributes_details": [
    {
      "id": 2,
      "name": "Size",
      "created": "2025-01-14T09:44:13.310154+03:00",
      "modified": "2025-01-22T23:07:27.267069+03:00",
      "value": "Large",
      "created_by": null,
      "updated_by": null,
      "attribute": 1
    },
    {
      "id": 1,
      "name": "Color",
      "created": "2025-01-14T09:43:57.773271+03:00",
      "modified": "2025-01-14T09:43:57.773307+03:00",
      "value": "Green",
      "created_by": null,
      "updated_by": null,
      "attribute": 2
    }
  ],
  "product_image": "https://api.expensetracker.wavvy.dev/media/a364b7a7-e498-4139-9e3a-f0ecb3e6b327.png",
  "product_cache_image": "https://api.expensetracker.wavvy.dev/media/CACHE/images/a364b7a7-e498-4139-9e3a-f0ecb3e6b327/4d7f56f3a5f7a15c35dfefdf797cdfff.jpg",
  "product_avatar_image": null,
  "shop_name": "Sisitech",
  "created": "2025-01-14T11:07:27.245123+03:00",
  "modified": "2025-04-09T18:52:07.797821+03:00",
  "name": null,
  "nickname": null,
  "description": null,
  "active": true,
  "sku": "SHLG",
  "price": "2500.00",
  "discount": "0.00",
  "initial_stock": 0,
  "stock": 8,
  "low_stock_threshold": 10,
  "thumbnail_url": null,
  "poster_url": null,
  "preview_url": null,
  "sprites_url": null,
  "created_by": null,
  "updated_by": null,
  "product": 1,
  "shop": 2,
  "attributes": ["2", "1"]
};

class ProductVariantPage extends StatelessWidget {
  const ProductVariantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productVariantController = Get.put(ProductVariantController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
            productVariantController.isUpdateMode.value ? "Update Product Variant" : "Create Product Variant")),
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
                child: Obx(() => Row(
                      children: [
                        Icon(
                          productVariantController.isUpdateMode.value
                              ? Icons.edit
                              : Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            productVariantController.isUpdateMode.value
                                ? "Update Mode: Editing existing product variant"
                                : "Create Mode: Adding new product variant",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Switch(
                          value: productVariantController.isUpdateMode.value,
                          onChanged: (_) => productVariantController.toggleMode(),
                          activeColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() => MyCustomForm(
                      key: ValueKey(
                          "${productVariantController.isUpdateMode.value}_${productVariantController.toggleCounter.value}"),
                      name: productVariantController.isUpdateMode.value
                          ? "ProductVariantFormUpdate"
                          : "ProductVariantFormCreate",
                      formItems: productVariantOptions,
                      formTitle: "Product Variant Information",
                      url: "api/v1/product-variants/",
                      contentType: ContentType.json,
                      instance: productVariantController.isUpdateMode.value
                          ? productVariantInstance
                          : null,
                      onControllerSetup: (contr) {
                        // Form controller is set up automatically
                      },
                      onSuccess: (value) {
                        dprint(productVariantController.isUpdateMode.value
                            ? "Product variant updated successfully:"
                            : "Product variant created successfully:");
                        dprint(value);

                        Get.snackbar(
                          "Success",
                          productVariantController.isUpdateMode.value
                              ? "Product variant updated successfully!"
                              : "Product variant created successfully!",
                          backgroundColor: Colors.green.withValues(alpha: 0.8),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                        );
                      },
                      handleErrors: (errors) {
                        dprint(productVariantController.isUpdateMode.value
                            ? "Product variant update errors:"
                            : "Product variant creation errors:");
                        dprint(errors);
                        return productVariantController.isUpdateMode.value
                            ? "Failed to update product variant. Please check your inputs."
                            : "Failed to create product variant. Please check your inputs.";
                      },
                      formGroupOrder: const [
                        ['attributes'],
                        ['name', 'nickname'],
                        ['price', 'sku'],
                        ['original_file'],
                      ],
                      submitButtonText: "Product Variant",
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