library flutter_form;

import 'dart:io';
import 'package:flutter_auth/auth_connect.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/models.dart';
import 'package:get/get.dart';

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
      {contentType = "application/json", shouldRemoveNullFields = true}) {
    var url = "${config!.apiEndpoint}/${path}";
    dprint(url);
    var dataToPatch;
    if (shouldRemoveNullFields) {
      dataToPatch = removeNullFields(body);
    } else {
      dataToPatch = body;
    }
    return patch(url, dataToPatch, contentType: contentType);
  }

  Future<Response> formPut(String? path, dynamic body,
      {contentType = "application/json", shouldRemoveNullFields = true}) {
    var url = "${config!.apiEndpoint}/${path}";
    dprint(url);
    var dataToPatch;
    if (shouldRemoveNullFields) {
      dataToPatch = removeNullFields(body);
    } else {
      dataToPatch = body;
    }
    return put(url, dataToPatch, contentType: contentType);
  }

  Future<Response> formPostMultipart(String? path, Map<String, dynamic> formData) async {
    var url = "${config!.apiEndpoint}/$path";
    dprint("Multipart POST to: $url");
    
    try {
      var form = FormData({});
      
      // Process form data and detect files
      for (var entry in formData.entries) {
        var key = entry.key;
        var value = entry.value;
        
        if (value != null) {
          if (value is String && _isFilePath(value)) {
            // Handle file upload
            var file = File(value);
            if (await file.exists()) {
              form.files.add(MapEntry(
                key,
                MultipartFile(file, filename: file.path.split('/').last),
              ));
              dprint("Added file: $key -> $value");
            } else {
              dprint("File not found: $value");
              form.fields.add(MapEntry(key, value)); // Add as regular field if file doesn't exist
            }
          } else {
            // Handle regular form fields
            form.fields.add(MapEntry(key, value.toString()));
            dprint("Added field: $key -> $value");
          }
        }
      }
      
      // Use GetConnect's post method with FormData
      return post(url, form);
      
    } catch (e) {
      dprint("Multipart upload error: $e");
      // Return error response
      return Future.value(Response(
        statusCode: 500,
        body: {'error': 'Multipart upload failed: $e'},
        statusText: 'Internal Server Error',
      ));
    }
  }
  
  bool _isFilePath(String value) {
    // Check if the string looks like a file path
    return value.contains('/') && 
           (value.contains('.') || value.startsWith('/')) &&
           value.length > 3;
  }

  @override
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
