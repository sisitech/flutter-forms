import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/shop_form_page.dart';
import '../pages/product_variant_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.apps,
                  size: 48,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 8),
                Text(
                  'Flutter Forms',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Example App',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to home if not already there
              if (Get.currentRoute != '/') {
                Get.offAllNamed('/');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Teacher Form'),
            onTap: () {
              Navigator.pop(context);
              // The teacher form is part of the home page
              if (Get.currentRoute != '/') {
                Get.offAllNamed('/');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Shop Form'),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => const ShopFormPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Product Variant'),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => const ProductVariantPage());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Add settings functionality later
              Get.snackbar(
                "Info",
                "Settings page coming soon!",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Flutter Forms',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.apps),
                children: [
                  const Text('A demonstration app for the flutter_form package.'),
                  const SizedBox(height: 8),
                  const Text('Features:'),
                  const Text('• Dynamic form generation'),
                  const Text('• File and image uploads'),
                  const Text('• Offline support'),
                  const Text('• Multipart form data'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}