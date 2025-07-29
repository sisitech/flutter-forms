import 'package:get/get.dart';
import '../pages/shop_form_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String shopForm = '/shop-form';
  
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: home,
        page: () => const ShopFormPage(), // This will be updated when we have a proper home page
      ),
      GetPage(
        name: shopForm,
        page: () => const ShopFormPage(),
      ),
    ];
  }
}

class NavigationHelper {
  static void goToHome() {
    Get.offAllNamed(AppRoutes.home);
  }
  
  static void goToShopForm() {
    Get.toNamed(AppRoutes.shopForm);
  }
  
  static void goBack() {
    if (Get.routing.current != AppRoutes.home) {
      Get.back();
    } else {
      goToHome();
    }
  }
}