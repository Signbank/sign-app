import 'package:sign_app/controllers/base_controller.dart';
import 'package:sign_app/models/token_data.dart';
import 'package:sign_app/url_config.dart';

class LoginController extends Controller {
  LoginController();

  final _loginEndpoint = "/login/";
  final _registerEndpoint = "/register/";

  Future<TokenData?> login(String username, String password) async {
    Map<String, String> body = {"username": username, "password": password};
    var returnData = await super.postRequest(
        url: signAppBaseUrl + _loginEndpoint,
        fromJsonFunction: TokenData.fromJson,
        body: body);

    return returnData;
  }

  Future<TokenData?> register(String username, String password, String email) async {

    Map<String, String> body = {"email": email, "username": username, "password": password};

    var returnData = await super.postRequest(
        url: signAppBaseUrl + _registerEndpoint,
        fromJsonFunction: _tokenDataFromJson,
        body: body);

    return returnData;
  }


  TokenData _tokenDataFromJson(Map<String, dynamic> json){
    return TokenData(
      token: json['token'],
      expiry: DateTime.now().toString(),
    );
  }
}
