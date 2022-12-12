import 'package:get/get.dart';

class FormProvider extends GetConnect {
  @override
  void onInit() {
    // All request will pass to jsonEncode so CasesModel.fromJson()
    httpClient.baseUrl = 'https://api.covid19api.com';
    // baseUrl = 'https://api.covid19api.com'; // It define baseUrl to
    // Http and websockets if used with no [httpClient] instance
    httpClient.addRequestModifier<dynamic>((request) async {
      final response = await get("http://yourapi/token");
      final token = response.body['token'];
      // Set the header
      request.headers['Authorization'] = "$token";
      return request;
    });
  }

  // Get request
  Future<Response> getUser(int id) => get('http://youapi/users/$id');
  // Post request

}
