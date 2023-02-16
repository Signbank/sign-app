import 'dart:convert';

import 'package:sign_app/controller/base_controller.dart';
import 'package:sign_app/url_config.dart';

class PropertyListController extends Controller {
  PropertyListController();

  String _propertyType = '';
  List<String> _properties = List.empty();

  late Function _callback;
  final List<int> _chosenProperties = List.empty(growable: true);

  void fetchProperties() async {
    var returnData = await super.postRequest<Map<String, dynamic>>(
        url: '$signAppBaseUrl/search',
        body: _chosenProperties,
        fromJsonFunction: (String json) { return jsonDecode(json);});

    if(returnData == null){
     return;
    }

    var typeOfData = returnData.keys.first;

    if(typeOfData == 'signs'){
      List<int> listOfSignIds = List<int>.from(returnData[typeOfData]);
      _callback(listOfSignIds);
      return;
    }

    _propertyType = typeOfData;
    _properties = List<String>.from(returnData[typeOfData]);
    _callback(null);
    return;
  }

  ///Getters
  List<String> get getPropertyList => _properties;

  String getProperty(int index) => _properties[index];

  String get getPropertyType => _propertyType;

  ///Setters
  void addChosenProperty(int index) {
    _chosenProperties.add(index);
    fetchProperties();
  }

  set setCallback(Function callback) => _callback = callback;
}
