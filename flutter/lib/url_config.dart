import 'package:flutter/foundation.dart';

bool _signAppLocalhost = false;
bool _signBankLocalhost = false;

const String _signAppBaseUrl = 'https://signapp.cls.ru.nl/api';
const String signAppLocalHostUrl = 'http://10.0.2.2:8000';
String get  signAppBaseUrl => _signAppLocalhost && kDebugMode  ? signAppLocalHostUrl : _signAppBaseUrl  ;

const String _signAppResetPasswordUrl = '/auth/password_reset/';
get signAppResetPasswordUrl => Uri.parse(signAppBaseUrl+_signAppResetPasswordUrl);

const String _signBankBaseUrl = 'https://signbank.cls.ru.nl';
const String _signBankLocalHostUrl = 'http://10.0.2.2:8080';
get  signBankBaseUrl => _signBankLocalhost && kDebugMode  ? _signBankLocalHostUrl : _signBankBaseUrl  ;

String _signBankBaseMediaUrl = '$_signBankBaseUrl/dictionary/protected_media/';
get  signBankBaseMediaUrl => _signBankBaseMediaUrl;
