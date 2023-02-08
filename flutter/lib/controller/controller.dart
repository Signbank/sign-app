import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sign_app/models/base_model.dart';

class Controller {
  Controller();

  late Model _data;
  late Function _callback;

  Future fetchData(var url) async {
    try {
      http.Response response;
      response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to load Signs. Error code: ${response.statusCode}');
      }
        _data = json
            .decode(response.body)
            .map((data) => Model.fromJson(data))
            .cast<Model>();

        _callback();
    } catch (e) {

    }
  }
}
