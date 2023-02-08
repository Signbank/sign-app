import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sign_app/app_config.dart';
import 'package:sign_app/models/property.dart';
import 'package:sign_app/models/property_index.dart';
import 'package:sign_app/models/property_type_object.dart';

class PropertyListController {
  PropertyListController();

  PropertyTypeObject _propertyTypeObject =
      PropertyTypeObject(groupType: '', properties: List.empty());
  late Function _callback;
  final List<PropertyIndex> _chosenProperties = List.empty(growable: true);

  Future<void> fetchProperties() async {
    try {
      var url = Uri.parse(signAppBaseUrl+'search');

      var body = json.encode(_chosenProperties);

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load Properties. Error code: ${response.statusCode}');
      }

      var jsonResponse = json.decode(response.body);

      if (jsonResponse.runtimeType != List) {
        Iterable values = jsonResponse.values;
        String groupType = values.first;
        var propertyList = List<Property>.from(
            jsonResponse['properties'].map((p) => Property.fromJson(p)));

        _propertyTypeObject =
            PropertyTypeObject(groupType: groupType, properties: propertyList);

        _callback(null);
        return;
      }

      List<int> listOfSignIds = jsonDecode(response.body).cast<int>();
      _callback(listOfSignIds);
    } catch (e) {
      //todo implement error handling
      print(e);
    }
  }

  ///Getters
  List<Property> get getPropertyList => _propertyTypeObject.properties;

  Property getProperty(int index) => _propertyTypeObject.properties[index];

  String get getPropertyType => _propertyTypeObject.groupType;

  ///Setters
  void addChosenProperty(PropertyIndex propertyIndex) {
    _chosenProperties.add(propertyIndex);
    fetchProperties();
  }

  set setCallback(Function callback) => _callback = callback;
}
