import 'dart:convert';

import 'package:flutter_auth/auth_connect.dart';
import 'package:flutter_auth/flutter_auth_controller.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/models.dart';
import 'package:flutter_utils/network_status/network_status_controller.dart';
import 'package:flutter_utils/offline_http_cache/offline_http_cache.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<dynamic> handleOfflineRecords(String taskName) async {
  // var netCont = Get.put(NetworkStatusController());

  var successfulRecords = [];
  dprint("Handling very iofad offline forms");
  var authCont = Get.put(AuthController());
  dprint("Auth Initialized");

  var offlineCont = Get.put(OfflineHttpCacheController());
  dprint("Done with controllers");

  var taskNameParts = taskName.split(".");
  String storageContainerName = "GetStorage";
  var taskPrefix = "";
  if (taskNameParts.length > 1) {
    storageContainerName = taskNameParts[1];
    taskPrefix = taskNameParts[0];
  }

  dprint("Preparing storage $storageContainerName");

  await GetStorage.init(storageContainerName);
  dprint("Storage ready");

  try {
    dprint("Gettint keyarsytdadaea0i98z $storageContainerName");
    var keys = await offlineCont.getOfflineKeys(storageContainerName);
    dprint(keys);
    int errors = 0;
    final box = GetStorage(storageContainerName);
    for (var key in keys) {
      dprint("Key $key . Error $errors");

      if (errors > 3) {
        break;
      }
      try {
        var dataMap = await box.read<Map<String, dynamic>>(key);
        if (dataMap != null) {
          var data = OfflineHttpCall.fromJson(dataMap);
          var res = await makeHttpCall(data, taskPrefix);
          if (!res) {
            errors = errors + 1;
          } else {
            successfulRecords.add({storageContainerName: key});
          }
        }
      } catch (e, stacktrace) {
        dprint("Inner errors");
        dprint(e);
        dprint(stacktrace);
        errors = errors + 1;
        continue;
      }
    }
    if (errors > 0) {
      return Future.value(successfulRecords);
    }
    return Future.value(successfulRecords);
  } catch (e, stacktrace) {
    dprint("Main error");
    dprint(e);
    dprint(stacktrace);
    return Future.value(false);
  }
}

Future<bool> makeHttpCall(
    OfflineHttpCall offlineData, String taskPrefix) async {
  var authProv = Get.find<AuthProvider>();
  var offlineCont = Get.find<OfflineHttpCacheController>();

  Response res;
  const successStatusCodes = [200, 201, 204];
  try {
    var body_str = offlineData.formData;
    Map<String, dynamic> body;

    dprint(body_str.runtimeType);
    if (body_str.runtimeType == String) {
      body = json.decode(body_str);
    } else {
      if (body_str != null) {
        body = body_str;
      } else {
        body = {"da": ""};
      }
    }
    dprint("Amb acking.. ${offlineData.httpMethod}");

    // return Future.value(true);
    if (offlineData.httpMethod == "GET") {
      res = await authProv.formGet(offlineData.urlPath);
    } else if (offlineData.httpMethod == "PATCH") {
      res = await authProv.formPatch(offlineData.urlPath, body);
    } else {
      res = await authProv.formPost(offlineData.urlPath, body);
    }
    dprint("Done getting..");
    dprint(res.statusCode);
    if (successStatusCodes.contains(res.statusCode)) {
      dprint(res.statusCode);
      dprint(res.body);
      await removeOfflineHttpCallOnSuccess(offlineData);
      return Future.value(true);
    } else {
      dprint(res.statusCode);
      dprint(res.body);
      offlineData.tries += 1;
      final box = GetStorage(offlineData.storageContainer);
      await box.write(offlineData.id, offlineData.toJson());
    }
    return Future.value(false);
  } catch (e, stacktrace) {
    dprint(e);
    dprint(stacktrace);
    return Future.value(false);
  }
}

removeOfflineHttpCallOnSuccess(OfflineHttpCall offlineData) {
  final box = GetStorage(offlineData.storageContainer);
  return box.remove(offlineData.id);
}
