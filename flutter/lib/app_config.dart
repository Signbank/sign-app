import 'package:flutter/foundation.dart';

bool _localhost = true;

var _signAppBaseUrl = 'example.com/';
var _signAppLocalHostUrl = 'http://10.0.2.2';
get  signAppBaseUrl => _localhost && kDebugMode  ? _signAppLocalHostUrl : _signAppBaseUrl  ;

var _signBankBaseUrl = 'https://signbank.cls.ru.nl';
var _signBankLocalHostUrl = 'http://10.0.2.2:8080';
get  signBankBaseUrl => _localhost && kDebugMode  ? _signBankLocalHostUrl : _signBankBaseUrl  ;


var _signBankBaseMediaUrl = '$_signBankBaseUrl/dictionary/protected_media';
get  signBankBaseMediaUrl => _signBankBaseMediaUrl;