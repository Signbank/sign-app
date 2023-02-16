import 'package:sign_app/controller/base_controller.dart';
import 'package:sign_app/models/property.dart';
import 'package:sign_app/url_config.dart';

class PropertyListController extends Controller {
  PropertyListController(this._callback);

  List<Property> _properties = List.empty();

  final Function _callback;
  final List<int> _chosenProperties = List.empty(growable: true);

  Future<void> fetchProperties() async {
    var returnData = await super.postRequest<List<Property>>(
        url: '$signAppBaseUrl/search',
        body: _chosenProperties,
        fromJsonFunction: Property.listFromJson);

    if (returnData == null) {
      return;
    }

    if (returnData.isEmpty) {
      var lastChosenProperty = _properties[_chosenProperties.last];
      _callback(lastChosenProperty.signIDs);
      return;
    }

    _properties = returnData;
    _callback(null);
    return;
  }

  ///Getters
  List<Property> get getPropertyList => _properties;

  Property getProperty(int index) => _properties[index];

  String getPropertyName(int index) => _properties[index].identifier;

  ///Setters
  void addChosenProperty(int index) {
    _chosenProperties.add(index);
    fetchProperties();
  }

  set setProperties(properties) => _properties = properties;
}
