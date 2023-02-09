import 'dart:convert';
import 'package:sign_app/url_config.dart';
import 'package:sign_app/models/sign.dart';
import 'package:http/http.dart' as http;

class SignListController {
  SignListController();

  List<Sign> _signList = List.empty();
  late String _searchTerm;
  late List<int> _singIds;
  late Function _callback;

  Future fetchSigns() async {
    try {
      http.Response response;
      if (_singIds.isNotEmpty) {
        var url = Uri.parse('$signBankBaseUrl/dictionary/gloss/api/');
        var body = jsonEncode(_singIds);

        response = await http.post(url,
            headers: {"Content-Type": "application/json"}, body: body);
      } else {
        var url = Uri.https(signBankBaseUrl, 'dictionary/gloss/api/',
            {'search': _searchTerm, 'dataset': 5, 'results': 50});
        response = await http.get(url);
      }

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load Signs. Error code: ${response.statusCode}');
      }
      _signList = json
          .decode(response.body)
          .map((data) => Sign.fromJson(data))
          .toList()
          .cast<Sign>();

      _callback();
    } catch (e) {
      //todo implement error handling
    }
  }

  ///Getters
  List<Sign> get signList => _signList;

  Sign getSign(int index) => _signList[index];

  String getSignName(int index) => _signList[index].name;

  String getSignImageUrl(int index) => _signList[index].imageUrl;

  ///Setters
  set setCallback(Function callback) => _callback = callback;

  set setSearchTerm(String searchTerm) => _searchTerm = searchTerm;

  set setSignIds(List<int> signIds) => _singIds = signIds;
}
