class PropertyIndex {
  final int group;
  final int index;

  const PropertyIndex({
    required this.group,
    required this.index,
  });

  factory PropertyIndex.fromJson(Map<String, dynamic> json){
    return PropertyIndex(
      index: json['index'],
      group: json['group'],
    );
  }


  Map<String, dynamic> toJson() => {
    'group': group,
    'index': index,
  };
}
