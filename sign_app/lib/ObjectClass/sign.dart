class Sign {
  final String name;
  final String videoUrl;
  final String imageUrl;

  const Sign({
    required this.name,
    required this.videoUrl,
    required this.imageUrl,
  });

  factory Sign.fromJson(Map<String, dynamic> json){
    return Sign(
      name: json['sign_name'],
      videoUrl: json['video_url'],
      imageUrl: json['image_url'],
    );
  }
}