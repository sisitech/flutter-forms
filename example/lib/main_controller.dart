import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/offline_http_cache/offline_http_cache.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyMainController extends SuperController {
  RxList<OfflineHttpCall> ofllineData = RxList.empty();

  var offlineCont = Get.find<OfflineHttpCacheController>();
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  getAllOfflineData() async {
    dprint("The offline keys are");
    dprint(await offlineCont.getOfflineKeys("school"));
    ofllineData.value = await offlineCont.getOfflineCaches("school");
    var box = GetStorage("school");
    dprint(await box.getKeys());
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllOfflineData();
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
    getAllOfflineData();
  }
}
