import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:newappc/constants.dart';

class ApiClient {
  final Dio dio;

  ApiClient({
    this.dio,
  });

  Future<Map<String, dynamic>> headerBuilder() async {
    String token = await fb.FirebaseAuth.instance.currentUser.getIdToken();
    Map<String, dynamic> map = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*",
      'Content-Type': 'application/json',
      'Authorization': token
    };
    return map;
  }

  Future<Map<String, dynamic>> get(
      {String endpoint,
      Map<String, dynamic> parameters = const {},
      Map<String, dynamic> header}) async {
    Map<String, dynamic> requestHeader = await headerBuilder();
    if (header != null) {
      requestHeader.addAll(header);
    }
    return _makeRequest(
      requestFunction: () => Dio().get(
        '$ip$endpoint',
        queryParameters: parameters,
        options: Options(headers: requestHeader),
      ),
    );
  }

  Future<Map<String, dynamic>> post(
      {String endpoint, Map<String, dynamic> data, Map<String, String> header}) async {
    Map<String, dynamic> requestHeader = await headerBuilder();
    if (header != null) {
      requestHeader.addAll(header);
    }
    return _makeRequest(
      requestFunction: () => Dio().post(
        '$ip$endpoint',
        data: data,
        options: Options(headers: requestHeader),
      ),
    );
  }

  Future<Map<String, dynamic>> put({
    String endpoint,
    Options options,
    dynamic data,
    Map<String, String> header,
  }) async {
    Map<String, dynamic> requestHeader = await headerBuilder();
    if (header != null) {
      requestHeader.addAll(header);
    }
    return _makeRequest(
      requestFunction: () => Dio().put(
        '$ip$endpoint',
        data: data,
        options: Options(headers: requestHeader),
      ),
    );
  }

  Future<Map<String, dynamic>> delete({
    String endpoint,
    Map<String, String> header,
  }) async {
    Map<String, dynamic> requestHeader = await headerBuilder();
    if (header != null) {
      requestHeader.addAll(header);
    }
    return _makeRequest(
      requestFunction: () => Dio().delete(
        '$ip$endpoint',
        options: Options(headers: requestHeader),
        data: {},
      ),
    );
  }

  Future<Map<String, dynamic>> _makeRequest<T>({
    Future<Response<dynamic>> Function() requestFunction,
  }) async {
    try {
      final response = await requestFunction();
      if (response.data is String) {
        return json.decode(response.data);
      } else {
        return response.data;
      }
    } catch (exception) {
      print('ERROR');
    }
    return null;
  }
}
