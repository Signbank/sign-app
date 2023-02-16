class Property{
  final String identifier;
  final List<int> signIDs;

  const Property({
    required this.identifier,
    required this.signIDs
  });

  factory Property.fromJson(Map<String, dynamic> json){
    return Property(
      identifier: json['identifier'],
      signIDs: List<int>.from(json['sign_ids']),
    );
  }

  static List<Property> listFromJson(List<dynamic> json) {
    return json
        .map((data) => Property.fromJson(data as Map<String, dynamic>))
        .toList()
        .cast<Property>();
  }
}