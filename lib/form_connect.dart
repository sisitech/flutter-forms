import 'package:flutter_form/models.dart';
import 'package:flutter_form/utils.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

class FormProvider extends GetConnect {
  APIConfig? config;
  FormProvider() {
    config = Get.find<APIConfig>();
    // dprint(config.toString());
  }
  @override
  void onInit() {
    dprint(config);
    dprint("The base url is");
    dprint(httpClient.baseUrl);
    // httpClient.addRequestModifier<dynamic>((request) {
    //   request.headers['Authorization'] = 'Bearer sdfsdfgsdfsdsdf12345678';
    //   return request;
    // });
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

  Future<Response> formPost(String? path, dynamic body,
      {contentType = "application/json"}) {
    var url = "${config!.apiEndpoint}/${path}";
    return post(url, body, contentType: contentType);
  }

  Future<Response> formPostUrlEncoded(String? path, dynamic body,
      {contentType = "application/x-www-form-urlencoded"}) {
    var url = "${config!.apiEndpoint}/${path}";
    var bodyStr = mapToFormUrlEncoded(body);
    var contentType = "application/x-www-form-urlencoded";
    // dprint(url);
    return formPost(config!.tokenUrl, bodyStr, contentType: contentType);
  }

  mapToFormUrlEncoded(Map body) {
    var fields = [];
    body.forEach((key, value) {
      fields.add("${key}=${value}");
    });
    return fields.join("&");
  }
}
