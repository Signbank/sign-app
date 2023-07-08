class Sign{
  final int id;
  final String name;
  final String videoUrl;
  final String imageUrl;

  const Sign({
    required this.id,
    required this.name,
    required this.videoUrl,
    required this.imageUrl,
  });

  factory Sign.fromJson(Map<String, dynamic> json){
    if (json['id'] == null){
      json['id'] = 0;
    }
    return Sign(
      id: json['id'],
      name: json['sign_name'],
      videoUrl: json['video_url'],
      imageUrl: json['image_url'],
    );
  }

  static List<Sign> listFromJson(List<dynamic> json) {
    return json
        .map((data) => Sign.fromJson(data as Map<String, dynamic>))
        .toList()
        .cast<Sign>();
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'sign_name': name,
    'video_url': videoUrl,
    'image_url': imageUrl,
  };
}