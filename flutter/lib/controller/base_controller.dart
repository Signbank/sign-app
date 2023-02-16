import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class Controller {
  @protected
  Future<T?> getRequest<T>(
      {required String url, required Function fromJsonFunction}) async {
    return _parseResponse<T>(
        response: await http.get(Uri.parse(url)),
        fromJsonFunction: fromJsonFunction);
  }

  @protected
  Future<T?> postRequest<T>(
      {required String url,
      required dynamic body,
      required Function fromJsonFunction,
      Map<String, String> headers = const {
        "Content-Type": "application/json"
      }}) async {
    return _parseResponse<T>(
        response: await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(body),
        ),
        fromJsonFunction: fromJsonFunction);
  }

  T? _parseResponse<T>(
      {required http.Response response, required Function fromJsonFunction}) {
    try {
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load data. Error code: ${response.statusCode}');
      }

      return fromJsonFunction(jsonDecode(response.body));
    } catch (e) {
      //TODO: implement user friendly error handling
    }

    return null;
  }
}
