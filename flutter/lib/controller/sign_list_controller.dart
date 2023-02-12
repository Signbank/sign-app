import 'package:sign_app/controller/base_controller.dart';
import 'package:sign_app/url_config.dart';
import 'package:sign_app/models/sign.dart';

class SignListController extends Controller {
  SignListController();

  List<Sign> _signList = List.empty();
  late Function _callback;

  void fetchSigns({List<int> singIds = const [], String searchTerm = ''}) async {
    const endpointUrl = '/dictionary/gloss/api/';
    late List<Sign>? returnData;
    if (singIds.isNotEmpty) {
      returnData = await super.postRequest(
          url: signBankBaseUrl + endpointUrl,
          fromJsonFunction: _listFromJson,
          body: singIds);
    } else {
      returnData = await super.getRequest(
          url: signBankBaseUrl +
              endpointUrl +
              "search=$searchTerm,dataset=5,results=50",
          fromJsonFunction: _listFromJson);
    }

    if (returnData == null) {
      return;
    }

    _signList = returnData;
    _callback();
  }

  List<Sign> _listFromJson(List<dynamic> json) {
    return json
        .map((data) => Sign.fromJson(data as Map<String, dynamic>))
        .toList()
        .cast<Sign>();
  }

  ///Getters
  List<Sign> get signList => _signList;

  Sign getSign(int index) => _signList[index];

  String getSignName(int index) => _signList[index].name;

  String getSignImageUrl(int index) => _signList[index].imageUrl;

  ///Setters
  set setCallback(Function callback) => _callback = callback;
}
