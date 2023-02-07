import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/providers/hub_provider.dart';
import 'package:hawker_hub/services/api_exceptions.dart';
import 'package:hawker_hub/services/api_response.dart';
import 'package:hawker_hub/services/hub_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';

import 'hub_provider_test.mocks.dart';

@GenerateMocks([HubServices, XFile])
void main() {
  late HubProvider testHubProvider;
  late HubServices mockHubServices;
  late XFile mockXfileImage;
  var uuidGenerator = const Uuid();

  Hub createRandomHub({String? hubId}) {
    return Hub(
        hubId: hubId ?? uuidGenerator.v4(),
        hubRating: Random().nextDouble() * 5,
        hubPhoto: Random().toString(),
        hubName: Random().toString(),
        hubDescription: Random().toString(),
        hubCategory: Random().toString(),
        hubCostForTwo: Random().toString(),
        hubLocations: [
          HubLocation(
              hubAddress: Random().toString(),
              hubDaysOfOperation: ["Monday"],
              hubEndTime: "15:00",
              hubStartTime: "10:00",
              hubPhoneNumber: Random().toString(),
              hubLatitude: Random().nextDouble() * 100,
              hubLongitude: Random().nextDouble() * 100)
        ]);
  }

  // Setup is called before each test is run
  setUp(() {
    mockHubServices = MockHubServices();
    testHubProvider = HubProvider(mockHubServices);
    mockXfileImage = XFile("");
  });

  test("initial setup and values of all the members vars", () async {
    expect(testHubProvider.insertHubsResponse, isNull);
    expect(testHubProvider.selectedHubId, isNull);
    expect(testHubProvider.selectedHubLocationArrayIndex, isNull);
    expect(testHubProvider.updateHubsResponse, isNull);
  });

  test("test setSelectedHubIdAndLocationArrayIndex", () async {
    testHubProvider.setSelectedHubIdAndLocationArrayIndex("testHubId", 1);
    expect(testHubProvider.selectedHubId, "testHubId");
    expect(testHubProvider.selectedHubLocationArrayIndex, 1);
  });

  group("testing insertHub", () {
    Hub existingHub = createRandomHub(hubId: "123");
    setUp(() async {
      when(mockHubServices.fetchAllHubs())
          .thenAnswer((_) => Future.value([existingHub]));
      await testHubProvider.fetchAllHubs();
      expect(testHubProvider.hubs, isNotNull);
      expect(testHubProvider.hubs.requestStatus, RequestStatus.completed);
      expect(testHubProvider.hubs.data.length, 1);
    });

    test("test loading status", () async {
      Hub mockHub = createRandomHub();
      when(mockHubServices.insertHub(mockHub, mockXfileImage))
          .thenAnswer((_) => Future.value(mockHub));
      testHubProvider.insertHub(mockHub, mockXfileImage);
      expect(testHubProvider.insertHubsResponse, isNotNull);
      expect(testHubProvider.insertHubsResponse?.requestStatus,
          RequestStatus.loading);
    });

    test("test success", () async {
      Hub mockHub = createRandomHub();
      when(mockHubServices.insertHub(mockHub, mockXfileImage))
          .thenAnswer((_) => Future.value(mockHub));
      await testHubProvider.insertHub(mockHub, mockXfileImage);
      expect(testHubProvider.insertHubsResponse, isNotNull);
      expect(testHubProvider.insertHubsResponse?.requestStatus,
          RequestStatus.completed);
      expect(testHubProvider.insertHubsResponse?.data, mockHub);
      expect(testHubProvider.hubs.data.length, 2);
    });

    test("test success with existing hub - replace exisiting hub", () async {
      when(mockHubServices.insertHub(existingHub, mockXfileImage))
          .thenAnswer((_) => Future.value(existingHub));
      await testHubProvider.insertHub(existingHub, mockXfileImage);
      expect(testHubProvider.insertHubsResponse, isNotNull);
      expect(testHubProvider.insertHubsResponse?.requestStatus,
          RequestStatus.completed);
      expect(testHubProvider.insertHubsResponse?.data, existingHub);
      expect(testHubProvider.hubs.data.length, 1);
    });

    test("test failure by exception", () async {
      Hub mockHub = createRandomHub();
      when(mockHubServices.insertHub(mockHub, mockXfileImage))
          .thenThrow(ClientTimeoutException("Exceeded 5 seconds"));
      await testHubProvider.insertHub(mockHub, mockXfileImage);
      expect(testHubProvider.insertHubsResponse, isNotNull);
      expect(testHubProvider.insertHubsResponse?.requestStatus,
          RequestStatus.error);
      expect(testHubProvider.insertHubsResponse?.statusMessage,
          "Client Request Timedout: Exceeded 5 seconds");
    });
  });

  group("testing fetchAllHubs", () {
    test("test loading status", () async {
      when(mockHubServices.fetchAllHubs()).thenAnswer((_) => Future.value([]));
      testHubProvider.fetchAllHubs();
      expect(testHubProvider.hubs, isNotNull);
      expect(testHubProvider.hubs.requestStatus, RequestStatus.loading);
    });

    test("test success with empty list", () async {
      when(mockHubServices.fetchAllHubs()).thenAnswer((_) => Future.value([]));
      await testHubProvider.fetchAllHubs();
      expect(testHubProvider.hubs, isNotNull);
      expect(testHubProvider.hubs.requestStatus, RequestStatus.completed);
      expect(testHubProvider.hubs.data.length, 0);
    });

    test("test success with non empty list", () async {
      int randomLength = Random().nextInt(30);

      List<Hub> hubList = [];
      for (int i = 0; i < randomLength; i++) {
        hubList.add(createRandomHub());
      }
      when(mockHubServices.fetchAllHubs())
          .thenAnswer((_) => Future.value(hubList));
      await testHubProvider.fetchAllHubs();
      expect(testHubProvider.hubs, isNotNull);
      expect(testHubProvider.hubs.requestStatus, RequestStatus.completed);
      expect(testHubProvider.hubs.data.length, randomLength);
    });

    test("test failure by exception", () async {
      when(mockHubServices.fetchAllHubs())
          .thenThrow(ClientTimeoutException("Exceeded 5 seconds"));
      await testHubProvider.fetchAllHubs();
      expect(testHubProvider.hubs, isNotNull);
      expect(testHubProvider.hubs.requestStatus, RequestStatus.error);
      expect(testHubProvider.hubs.statusMessage,
          "Client Request Timedout: Exceeded 5 seconds");
    });
  });

  group("testing updateHub", () {
    Hub existingHub = createRandomHub(hubId: "123");
    setUp(() async {
      when(mockHubServices.fetchAllHubs())
          .thenAnswer((_) => Future.value([existingHub]));
      await testHubProvider.fetchAllHubs();
      expect(testHubProvider.hubs, isNotNull);
      expect(testHubProvider.hubs.requestStatus, RequestStatus.completed);
      expect(testHubProvider.hubs.data.length, 1);
    });

    test("test loading status", () async {
      Hub mockHub = createRandomHub();
      when(mockHubServices.updateHub(mockHub, mockXfileImage))
          .thenAnswer((_) => Future.value(mockHub));
      testHubProvider.updateHub(mockHub, mockXfileImage);
      expect(testHubProvider.updateHubsResponse, isNotNull);
      expect(testHubProvider.updateHubsResponse?.requestStatus,
          RequestStatus.loading);
    });

    test("test success", () async {
      Hub mockHub = createRandomHub();
      when(mockHubServices.updateHub(mockHub, mockXfileImage))
          .thenAnswer((_) => Future.value(mockHub));
      await testHubProvider.updateHub(mockHub, mockXfileImage);
      expect(testHubProvider.updateHubsResponse, isNotNull);
      expect(testHubProvider.updateHubsResponse?.requestStatus,
          RequestStatus.completed);
      expect(testHubProvider.updateHubsResponse?.data, mockHub);
      expect(testHubProvider.hubs.data.length, 2);
    });

    test("test success with existing hub - replace exisiting hub", () async {
      when(mockHubServices.updateHub(existingHub, mockXfileImage))
          .thenAnswer((_) => Future.value(existingHub));
      await testHubProvider.updateHub(existingHub, mockXfileImage);
      expect(testHubProvider.updateHubsResponse, isNotNull);
      expect(testHubProvider.updateHubsResponse?.requestStatus,
          RequestStatus.completed);
      expect(testHubProvider.updateHubsResponse?.data, existingHub);
      expect(testHubProvider.hubs.data.length, 1);
    });

    test("test failure by exception", () async {
      Hub mockHub = createRandomHub();
      when(mockHubServices.updateHub(mockHub, mockXfileImage))
          .thenThrow(ClientTimeoutException("Exceeded 5 seconds"));
      await testHubProvider.updateHub(mockHub, mockXfileImage);
      expect(testHubProvider.updateHubsResponse, isNotNull);
      expect(testHubProvider.updateHubsResponse?.requestStatus,
          RequestStatus.error);
      expect(testHubProvider.updateHubsResponse?.statusMessage,
          "Client Request Timedout: Exceeded 5 seconds");
    });
  });
}
