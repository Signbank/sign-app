class Property {
  final String identifier;
  final int group;
  final int index;

  const Property({
    required this.identifier,
    required this.group,
    required this.index,
  });

  factory Property.fromJson(Map<String, dynamic> json){
    return Property(
      identifier: json['identifier'],
      group: json['group'],
      index: json['index'],
    );
  }
}
