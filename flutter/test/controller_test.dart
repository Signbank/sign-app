import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:sign_app/controllers/property_list_controller.dart';
import 'package:sign_app/controllers/sign_list_controller.dart';
import 'package:http/testing.dart';
import 'package:sign_app/models/property.dart';

void main() {
  group('Sign list controller', () {
    test('Fetch sign data with search term', () async {
      var client = MockClient((request) async {
        return Response(
            json.encode([
              {
                "sign_name": "test",
                "video_url": "videoUrl",
                "image_url": "imageUrl"
              }
            ]),
            200,
            headers: {'content-type': 'application/json'});
      });

      SignListController controller = SignListController(() => {});

      controller.client = client;

      // Check if list is empty
      expect(controller.signList, []);

      await controller.fetchSigns(searchTerm: 'test');

      expect(controller.signList.length, 1);
    });

    test('Fetch sign data with list of sign ids', () async {
      var client = MockClient((request) async {
        return Response(
            json.encode([
              {
                "sign_name": "test",
                "video_url": "videoUrl",
                "image_url": "imageUrl"
              }
            ]),
            200,
            headers: {'content-type': 'application/json'});
      });
      SignListController controller = SignListController(() => {});

      controller.client = client;

      // Check if list is empty
      expect(controller.signList, []);

      await controller.fetchSigns(singIds: [0]);

      expect(controller.signList.length, 1);
    });
  });

  group('Property list controller', () {
    test('Fetch property data', () async {
      var client = MockClient((request) async {
        return Response(
            json.encode([
              {
                'identifier': 'test',
                'sign_ids': [0]
              }
            ]),
            200,
            headers: {'content-type': 'application/json'});
      });

      PropertyListController controller = PropertyListController((value) => {});

      controller.client = client;

      // Check if list is empty
      expect(controller.getPropertyList, []);

      await controller.fetchProperties();

      expect(controller.getPropertyList.length, 1);
    });

    test('Fetch property data', () async {
      var client = MockClient((request) async {
        return Response(json.encode([]), 200,
            headers: {'content-type': 'application/json'});
      });

      List<int> actual = [];
      List<int> expected = [1, 2, 3];

      PropertyListController controller =
          PropertyListController((value) => {actual = value});

      controller.setProperties = [Property(identifier: 'test', signIDs: expected)];
      controller.addChosenProperty(0);

      controller.client = client;

      await controller.fetchProperties();

      expect(actual, expected);
    });
  });
}
