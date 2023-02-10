import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/services/api_exceptions.dart';
import 'package:hawker_hub/services/http_client.dart';
import 'package:hawker_hub/services/hub_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'hub_services_test.mocks.dart';

@GenerateMocks([HttpClient, XFile])
void main() {
  late HttpClient mockHttpClient;
  late HubServices testHubServices;
  late XFile mockXfileImage;

  final Map<String, dynamic> hubAsJson = {
    "hub_cost_for_two": "123",
    "hub_category": "Other",
    "hub_rating": 5,
    "hub_name": "test hub",
    "hub_locations": [
      {
        "hub_days_of_operation": ["Monday", "Wednesday", "Friday"],
        "hub_start_time": "08:00",
        "hub_phone_number": "+1123456789",
        "hub_end_time": "20:00",
        "hub_latitude": 44.57418808742632,
        "hub_address": "123 NW 23rd St, Corvallis, Oregon 97330, United States",
        "hub_longitude": -123.27743701636791
      },
      {
        "hub_days_of_operation": ["Tuesday", "Saturday", "Thursday"],
        "hub_start_time": "08:00",
        "hub_phone_number": "+1987654321",
        "hub_end_time": "20:00",
        "hub_latitude": 44.57656130628247,
        "hub_address":
            "1115 NW 19th St, Corvallis, Oregon 97330, United States",
        "hub_longitude": -123.27305629849434
      }
    ],
    "hub_id": "c5cc19b3-4467-4219-86e4-086ae7e128f8",
    "hub_photo":
        "https://hubs-image.s3.amazonaws.com/c5cc19b3-4467-4219-86e4-086ae7e128f8.jpg",
    "hub_description": "test description"
  };

  Hub getStaticHub() {
    return Hub(
        hubId: "c5cc19b3-4467-4219-86e4-086ae7e128f8",
        hubRating: Random().nextDouble() * 5,
        hubPhoto: Random().toString(),
        hubName: Random().toString(),
        hubDescription: Random().toString(),
        hubCategory: Random().toString(),
        hubCostForTwo: Random().toString(),
        hubLocations: [
          HubLocation(
              hubAddress: Random().toString(),
              hubDaysOfOperation: const ["Monday"],
              hubEndTime: "15:00",
              hubStartTime: "10:00",
              hubPhoneNumber: Random().toString(),
              hubLatitude: Random().nextDouble() * 100,
              hubLongitude: Random().nextDouble() * 100)
        ]);
  }

  setUp(() {
    mockHttpClient = MockHttpClient();
    testHubServices = HubServices(mockHttpClient);
    mockXfileImage = XFile("");
  });

  group("testing success response", () {
    test("test fetchAllhubs - 1 hub response", () async {
      when(mockHttpClient.fetchData())
          .thenAnswer((_) => Future.value([hubAsJson]));

      List<Hub> result = await testHubServices.fetchAllHubs();
      expect(result, isNotNull);
      expect(result.length, 1);
    });

    test("test fetchAllhubs - no hub response", () async {
      when(mockHttpClient.fetchData()).thenAnswer((_) => Future.value([]));

      List<Hub> result = await testHubServices.fetchAllHubs();
      expect(result, isNotNull);
      expect(result.length, 0);
    });

    test("test insertHub", () async {
      Hub staticHub = getStaticHub();
      when(mockHttpClient.sendDataAndImage(
        "POST",
        staticHub,
        mockXfileImage,
      )).thenAnswer((_) => Future.value(hubAsJson));

      Hub result = await testHubServices.insertHub(staticHub, mockXfileImage);
      expect(result, isNotNull);
      expect(result.hubId, staticHub.hubId);
    });

    test("test updateHub", () async {
      Hub staticHub = getStaticHub();
      when(mockHttpClient.sendDataAndImage(
        "PUT",
        staticHub,
        mockXfileImage,
      )).thenAnswer((_) => Future.value(hubAsJson));

      Hub result = await testHubServices.updateHub(staticHub, mockXfileImage);
      expect(result, isNotNull);
      expect(result.hubId, staticHub.hubId);
    });
  });

  group("testing failure response", () {
    test("test fetchAllhubs", () async {
      when(mockHttpClient.fetchData())
          .thenThrow(InvalidInputException("Invalid input exception"));

      expect(() async => await testHubServices.fetchAllHubs(),
          throwsA(isA<InvalidInputException>()));
    });

    test("test insertHub", () async {
      Hub staticHub = getStaticHub();
      when(mockHttpClient.sendDataAndImage(
        "POST",
        staticHub,
        mockXfileImage,
      )).thenThrow(BadRequestException("Bad request exception"));

      expect(
          () async =>
              await testHubServices.insertHub(staticHub, mockXfileImage),
          throwsA(isA<BadRequestException>()));
    });

    test("test updateHub", () async {
      Hub staticHub = getStaticHub();
      when(mockHttpClient.sendDataAndImage(
        "PUT",
        staticHub,
        mockXfileImage,
      )).thenThrow(FetchDataException("fetch data exception"));

      expect(
          () async =>
              await testHubServices.updateHub(staticHub, mockXfileImage),
          throwsA(isA<FetchDataException>()));
    });
  });
}
