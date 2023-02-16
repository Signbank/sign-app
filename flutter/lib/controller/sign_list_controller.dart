import 'package:sign_app/controller/base_controller.dart';
import 'package:sign_app/url_config.dart';
import 'package:sign_app/models/sign.dart';

class SignListController extends Controller {
  SignListController(this._callback);

  List<Sign> _signList = List.empty();
  Function _callback;

  Future<void> fetchSigns({List<int> singIds = const [], String searchTerm = ''}) async {
    const endpointUrl = '/dictionary/gloss/api/';
    late List<Sign>? returnData;
    if (singIds.isNotEmpty) {
      returnData = await super.postRequest(
          url: signBankBaseUrl + endpointUrl,
          fromJsonFunction: Sign.listFromJson,
          body: singIds);
    } else {
      returnData = await super.getRequest(
          url: signBankBaseUrl +
              endpointUrl +
              "?search=$searchTerm&dataset=5&results=50",
          fromJsonFunction: Sign.listFromJson);
    }

    if (returnData == null) {
      return;
    }

    _signList = returnData;
    _callback();
  }

  ///Getters
  List<Sign> get signList => _signList;

  Sign getSign(int index) => _signList[index];

  String getSignName(int index) => _signList[index].name;

  String getSignImageUrl(int index) => _signList[index].imageUrl;

  ///Setters
  set setCallback(Function callback) => _callback = callback;
}
