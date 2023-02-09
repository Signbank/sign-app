import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sign_app/models/property.dart';
import 'package:sign_app/models/property_index.dart';
import 'package:sign_app/models/property_type_object.dart';
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

  test('Property object should be created', () {
    const identifier = 'test';
    const group = 1;
    const index = 1;
    const json = {'identifier': identifier, 'group': group, 'index': index};

    Property property = Property.fromJson(json);

    expect(property.identifier, identifier);
    expect(property.group, group);
    expect(property.index, index);
  });

  test('Property index object should be created', () {
    const group = 1;
    const index = 1;
    const json = {'group': group, 'index': index};

    PropertyIndex propertyIndex = PropertyIndex.fromJson(json);

    expect(propertyIndex.group, group);
    expect(propertyIndex.index, index);
  });

  test('Property index json should be created', () {
    const group = 1;
    const index = 1;
    PropertyIndex propertyIndex =
        const PropertyIndex(group: group, index: index);
    const expected = {"group": group, "index": index};

    var actual = propertyIndex.toJson();

    expect(actual, expected);
  });

  test('Property type object should be created', () {
    const groupType = 'test';
    const identifier = 'test id';
    const group = 1;
    const index = 1;
    const json = {
      'group_type': groupType,
      'properties': [
        {"identifier": identifier, "group": group, "index": index}
      ]
    };

    PropertyTypeObject propertyType = PropertyTypeObject.fromJson(json);
    var property = propertyType.properties[0];

    expect(propertyType.groupType, groupType);
    expect(property.identifier, identifier);
    expect(property.group, group);
    expect(property.index, index);
  });
}
