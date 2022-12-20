library flutter_form;

import 'package:flutter_auth/auth_connect.dart';
import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

class FormProvider extends AuthProvider {
  APIConfig? config;
  FormProvider() {
    config = Get.find<APIConfig>();
    // dprint(config.toString());
  }

  // Get request
  Future<Response> getUser(int id) => get('http://youapi/users/$id');

  Future<Response> login(Map body) async {
    dprint(body);
    var url = "${config!.apiEndpoint}/${config!.tokenUrl}";
    var bodyStr = mapToFormUrlEncoded(body);
    var contentType = "application/x-www-form-urlencoded";
    // dprint(url);
    return formPost(config!.tokenUrl, bodyStr, contentType: contentType);
  }

  Future<Response> formPatch(String? path, dynamic body,
      {contentType = "application/json"}) {
    var url = "${config!.apiEndpoint}/${path}";
    dprint(url);

    return patch(url, removeNullFields(body), contentType: contentType);
  }

  removeNullFields(Map<String, dynamic> formData) {
    dprint("formData");
    dprint(formData);
    Map<String, dynamic> res = {};
    formData.forEach((key, value) {
      if (value != null) {
        res[key] = value;
      }
    });
    return res;
  }
}
