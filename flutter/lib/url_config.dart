import 'package:flutter/foundation.dart';

bool _localhost = true;

const String _signAppBaseUrl = 'example.com/';
const String signAppLocalHostUrl = 'http://10.0.2.2:8000';
String get  signAppBaseUrl => _localhost && kDebugMode  ? signAppLocalHostUrl : _signAppBaseUrl  ;

const String _signBankBaseUrl = 'https://signbank.cls.ru.nl';
const String _signBankLocalHostUrl = 'http://10.0.2.2:8080';
get  signBankBaseUrl => _localhost && kDebugMode  ? _signBankLocalHostUrl : _signBankBaseUrl  ;


String _signBankBaseMediaUrl = '$_signBankBaseUrl/dictionary/protected_media';
get  signBankBaseMediaUrl => _signBankBaseMediaUrl;