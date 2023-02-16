import 'package:flutter_test/flutter_test.dart';
import 'package:sign_app/models/sign.dart';

void main() {
  test('Sign object should be created', () {
    const signName = 'test';
    const videoUrl = 'super cool link to video';
    const imageUrl = 'super cool link to image';
    const json = {
      'sign_name': signName,
      'video_url': videoUrl,
      'image_url': imageUrl
    };

    Sign sign = Sign.fromJson(json);

    expect(sign.name, signName);
    expect(sign.videoUrl, videoUrl);
    expect(sign.imageUrl, imageUrl);
  });
}
