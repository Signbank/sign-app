import 'package:flutter_test/flutter_test.dart';
import 'package:sign_app/models/property.dart';
import 'package:sign_app/models/sign.dart';

void main() {
  test('Create Sign object from JSON', () {
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

  test('Create Sign list from JSON', () {
    const signName = 'test';
    const videoUrl = 'super cool link to video';
    const imageUrl = 'super cool link to image';
    const json = [
      {'sign_name': signName, 'video_url': videoUrl, 'image_url': imageUrl}
    ];

    List<Sign> signList = Sign.listFromJson(json);

    expect(signList[0].name, signName);
    expect(signList[0].videoUrl, videoUrl);
    expect(signList[0].imageUrl, imageUrl);
  });

  test('Create Property object from JSON', () {
    const propertyIdentifier = 'test';
    const signIDs = [1, 2, 3];
    const json = {'identifier': propertyIdentifier, 'sign_ids': signIDs};

    Property property = Property.fromJson(json);

    expect(property.identifier, propertyIdentifier);
    expect(property.signIDs, signIDs);
  });

  test('Create Property list from JSON', () {
    const propertyIdentifier = 'test';
    const signIDs = [1, 2, 3];
    const json = [
      {'identifier': propertyIdentifier, 'sign_ids': signIDs}
    ];

    List<Property> propertyList = Property.listFromJson(json);

    expect(propertyList[0].identifier, propertyIdentifier);
    expect(propertyList[0].signIDs, signIDs);
  });
}
