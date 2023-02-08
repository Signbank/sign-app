import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sign_app/models/property.dart';
import 'package:sign_app/models/property_index.dart';

class PropertyListController {
  PropertyListController();

  late Function _callback;
  List<Property> _properties = List.empty(growable: true);
  final List<PropertyIndex> _chosenProperties = List.empty(growable: true);

  Future<void> fetchProperties() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8000/search');
      var body = json.encode(_chosenProperties);

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        try {
          _properties = json
              .decode(response.body)
              .map((data) => Property.fromJson(data))
              .toList()
              .cast<Property>();

          _callback();
        } on TypeError {
          // List<int> listOfSignIds = jsonDecode(response.body).cast<int>();

          // Check if the current widget is still on screen
          // if(mounted) {
          //   Navigator.of(context).pop();
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             SearchSignList(search: '', signIds: listOfSignIds,)),
          //   );
          // }
        }
      } else {
        throw Exception(
            'Failed to load Properties. Error code: ${response.statusCode}');
      }
    } catch (e) {
      //todo implement error handling
      return Future.delayed(const Duration(seconds: 3), () {
        _properties = List.filled(5, const Property(identifier: 'a', group: 0, index: 0));
        _callback();
      });
    }
  }

  ///Getters
  List<Property> get getPropertyList => _properties;
  Property getProperty(int index) => _properties[index];

  ///Setters
  void addChosenProperty(PropertyIndex propertyIndex) {
    _chosenProperties.add(propertyIndex);
    fetchProperties();
  }
  void addProperty(Property property) {
    _properties.add(property);
  }
  set setCallback(Function callback) => _callback = callback;

  Property removeLastProperty() => _properties.removeLast();
}
