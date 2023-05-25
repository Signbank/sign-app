import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_app/models/token_data.dart';

class TokenHelper {

  final String _tokenKey = 'token';
  final String _expiryKey = 'token_expiry';

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_tokenKey);
    if (token != null) {
      return token;
    }

    return "";
  }

  Future<void> saveToken(TokenData tokenData) async {
    SharedPreferences.getInstance().then((sharedPreferences) {
      sharedPreferences.setString(_tokenKey, "Token ${tokenData.token}");

      if(tokenData.expiry.isNotEmpty){
        sharedPreferences.setString(_expiryKey, tokenData.expiry);
        return;
      }

      sharedPreferences.setString(_expiryKey, DateTime.now().toString());
    });
  }
}
