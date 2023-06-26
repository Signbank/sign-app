import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:sign_app/error_handling.dart';
import 'package:sign_app/token_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class Controller {
  late Client client = Client();
  final String _authHeaderKey = "Authorization";
  late Map<String, String> headers = {
    _authHeaderKey: "",
    "Content-Type": "application/json",
  };


  @protected
  Future<T?> getRequest<T>(
      {required String url,
      required Function fromJsonFunction,
      requiresCredentials = false}) async {
    try {
      if (headers[_authHeaderKey]!.isEmpty && requiresCredentials) {
        var token = await TokenHelper().getToken();
        headers[_authHeaderKey] = token;
      }

      return _parseResponse<T>(
          response: await client.get(Uri.parse(url), headers: headers),
          fromJsonFunction: fromJsonFunction);
    } catch (e) {
      ErrorHandling().showError(e.toString(), ErrorLevel.error);
    }
    return null;
  }

  @protected
  Future<T?> postRequest<T>(
      {required String url,
      required dynamic body,
      required Function fromJsonFunction,
      requiresCredentials = false}) async {
    try {
      if (headers[_authHeaderKey]!.isEmpty && requiresCredentials) {
        var token = await TokenHelper().getToken();
        headers[_authHeaderKey] = token;
      }

      return _parseResponse<T>(
          response: await client.post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          ),
          fromJsonFunction: fromJsonFunction);
    } catch (e) {
      ErrorHandling().showError(e.toString(), ErrorLevel.error);
    }
    return null;
  }

  @protected
  Future<T?> putRequest<T>(
      {required String url,
      required dynamic body,
      required Function fromJsonFunction}) async {
    try {
      if (headers[_authHeaderKey]!.isEmpty) {
        var token = await TokenHelper().getToken();
        headers[_authHeaderKey] = token;
      }
      return _parseResponse<T>(
          response: await client.put(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          ),
          fromJsonFunction: fromJsonFunction);
    } catch (e) {
      ErrorHandling().showError(e.toString(), ErrorLevel.error);
    }
    return null;
  }

  @protected
  Future<T?> deleteRequest<T>({required String url}) async {
    try {
      if (headers[_authHeaderKey]!.isEmpty) {
        var token = await TokenHelper().getToken();
        headers[_authHeaderKey] = token;
      }
      return _parseResponse<T>(
          response: await client.delete(
        headers: headers,
        Uri.parse(url),
      ));
    } catch (e) {
      ErrorHandling().showError(e.toString(), ErrorLevel.error);
    }
    return null;
  }

  T? _parseResponse<T>(
      {required Response response, Function? fromJsonFunction}) {
    try {
      if (response.statusCode < 300) {
        if (fromJsonFunction == null) {
          return null;
        }

        return fromJsonFunction(jsonDecode(response.body));
      }

      if (response.statusCode >= 300) {
        switch (response.statusCode) {
          case 401:
            headers[_authHeaderKey] = "";
            var errorMessage = jsonDecode(response.body).values.first;
            throw Exception("$errorMessage");
          default:
            //Todo: get localizations for error messages, so it can be in the device language
            // var errorMessage = AppLocalizations.of(context)!.somethingWentWrong;
            throw Exception("Oops something went wrong, please try again later.");
        }
      }

      throw Exception(
          'Failed to load data. Error code: ${response.statusCode}');
    } catch (e) {
      ErrorHandling().showError(e.toString(), ErrorLevel.error);
    }

    return null;
  }
}
