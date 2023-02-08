import 'dart:convert';
import 'package:mvc_application/controller.dart';
import 'package:sign_app/models/sign.dart';
import 'package:http/http.dart' as http;

class SignListController extends ControllerMVC {
  /// Instantiate singleton class
  static final SignListController _this = SignListController._();

  /// Create private constructor
  SignListController._();

  /// Static method to get singleton instance
  static SignListController get con => _this;

  late List<Sign> signList;
  late String searchTerm;
  late List<int> singIds;

  @override
  void initState() {
    super.initState();

    fetchSigns();
  }

  Future fetchSigns() async {
    http.Response response;
    if (singIds.isNotEmpty) {
      var url = Uri.parse('http://10.0.2.2:8080/dictionary/gloss/api/');
      var body = jsonEncode(singIds);

      response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);
    } else {
      var url =
          'http://10.0.2.2:8080/dictionary/gloss/api/?search=$searchTerm&dataset=5&results=50';
      response = await http.get(Uri.parse(url));
    }

    if (response.statusCode == 200) {
      signList = json
          .decode(response.body)
          .map((data) => Sign.fromJson(data))
          .toList()
          .cast<Sign>();

      refresh();
    } else {
      signList = List.filled(5, const Sign(name: 'name', videoUrl: 'vid url', imageUrl: 'im url'));
      // throw Exception(
      //     'Failed to load Signs. Error code: ${response.statusCode}');
    }
  }

  Sign getSign(int index) => signList[index];

  String getSignName(int index) => signList[index].name;

  String getSignImageUrl(int index) => signList[index].imageUrl;
}
