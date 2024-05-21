import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:optimo/constants/api_constant.dart';


class ServerRequest {

  static String baseUrl = ApiConstant.baseUrl;

  static final Map<String, String> basicHeader =  {
    'Accept':'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const String noInternetMessage =
      'Connection to API server failed due to internet connection';


  static Future<dynamic> getData(String path, Map<String, String> headers) async {
    String getUrl = baseUrl + path;
    try {
      http.Response response = await http
          .get(Uri.parse(getUrl), headers: headers)
          .timeout(const Duration(seconds: 30));
      return response;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<dynamic> postData(String path, Map<String, String> headers, dynamic body) async {
    String postUrl = baseUrl + path;
    try {
      http.Response response = await http
          .post(Uri.parse(postUrl), headers: headers, body: body)
          .timeout(const Duration(seconds: 30));
      return response;
    } on Exception catch (_) {
      print("exception occurred");
      return null;
    }
  }

  static Future<dynamic> putData(String path, Map<String, String> headers, dynamic body) async {
    String putUrl = baseUrl + path;
    try {
      http.Response response = await http
          .put(Uri.parse(putUrl), headers: headers, body: body)
          .timeout(const Duration(seconds: 30));
      return response;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<dynamic> patchData(String path, Map<String, String> headers,  dynamic body) async {
    String updateUrl = baseUrl + path;
    try {
      http.Response response = await http
          .patch(Uri.parse(updateUrl), headers: headers, body: body)
          .timeout(const Duration(seconds: 30));
      return response;
    } on Exception catch (_) {
      log("Exception Occurred in server request");
      return null;
    }
  }

  static Future<dynamic> deleteData(String path, Map<String, String> headers) async {
    String deleteUrl = baseUrl + path;
    try {
      http.Response response = await http
          .delete(Uri.parse(deleteUrl), headers: headers)
          .timeout(const Duration(seconds: 30));
      return response;
    } on Exception catch (_) {
      return null;
    }
  }

  static Future<dynamic> formData({
    required String method,
    required String path,
    required Map<String, String> headers,
    Map<String, String>? textFields,
    List<http.MultipartFile>? fileFields,
  }) async {
    String postUrl = ApiConstant.baseUrl+ApiConstant.uploadStatement;
    http.MultipartRequest request = http.MultipartRequest(method, Uri.parse(postUrl));
    request.headers.addAll(headers);

    if (textFields != null) {
      request.fields.addAll(textFields);
    }
    if (fileFields != null) {
      request.files.addAll(fileFields);
    }
    try {
      EasyLoading.show();
      var response = await request.send();
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(await response.stream.bytesToString());
        return responseBody;
      } else if (response.statusCode == 413) {
        print('file is too large');
        return null;
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e);
      EasyLoading.dismiss();
      return null;
    }
  }

  void handleErrorResponse(http.Response response) {
    if (response.statusCode == 400) {
    } else if (response.statusCode == 401) {
    } else if (response.statusCode == 403) {
    } else if (response.statusCode == 404) {
    } else if (response.statusCode == 408) {
    } else if (response.statusCode == 500) {
    } else if (response.statusCode == 503) {
    } else if (response.statusCode == 504) {
    } else {}
  }
}