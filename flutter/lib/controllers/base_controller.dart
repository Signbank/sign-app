import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:http/http.dart';

abstract class Controller {
 Client client = Client();

  @protected
  Future<T?> getRequest<T>(
      {required String url, required Function fromJsonFunction}) async {
    return _parseResponse<T>(
        response: await client.get(Uri.parse(url)),
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
        response: await client.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(body),
        ),
        fromJsonFunction: fromJsonFunction);
  }

 @protected
 Future<T?> deleteRequest<T>(
     {required String url}) async {
   return _parseResponse<T>(
       response: await client.delete(
         Uri.parse(url),
       ));
 }

 T? _parseResponse<T>(
      {required Response response, Function? fromJsonFunction}) {
    try {
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load data. Error code: ${response.statusCode}');
      }
      if(fromJsonFunction == null){
        return null;
      }

      return fromJsonFunction(jsonDecode(response.body));
    } catch (e) {
      //TODO: implement user friendly error handling
      print(e);
    }

    return null;
  }
}
