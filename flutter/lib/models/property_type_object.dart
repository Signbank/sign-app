import 'package:sign_app/models/property.dart';

class PropertyTypeObject{
  final String groupType;
  final List<Property> properties;

  const PropertyTypeObject({
    required this.groupType,
    required this.properties,
  });

  factory PropertyTypeObject.fromJson(Map<String, dynamic> json){
    return PropertyTypeObject(
      groupType: json['group_type'],
      properties: List<Property>.from(json['properties'].map((item) => Property.fromJson(item))),
    );
  }
}