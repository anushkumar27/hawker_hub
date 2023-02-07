import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/providers/hub_provider.dart';
import 'package:hawker_hub/screens/search_screen.dart';
import 'package:hawker_hub/services/hub_services.dart';
import 'package:hawker_hub/widgets/hub_details_vertical_card.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'hub_provider_test.mocks.dart';

@GenerateMocks([HubServices])
void main() {
  late HubServices mockHubServices;
  late HubProvider testHubProvider;
  var uuidGenerator = const Uuid();

  Hub getHubDetails([String? hubName]) {
    return Hub(
        hubId: uuidGenerator.v4(),
        hubRating: 4.5,
        hubPhoto: "RANDOM_URL",
        hubName: hubName ?? "Mock Hub",
        hubDescription: "Mock Hub Description",
        hubCategory: "Others",
        hubCostForTwo: "99",
        hubLocations: [
          HubLocation(
              hubAddress: "Mock Hub Address",
              hubDaysOfOperation: ["Monday"],
              hubEndTime: "15:00",
              hubStartTime: "10:00",
              hubPhoneNumber: "123456789",
              hubLatitude: 141.1234,
              hubLongitude: 142.4321)
        ]);
  }

  Widget makeTestableWidget({required Widget child}) => MaterialApp(
        home: ChangeNotifierProvider<HubProvider>(
          create: (_) => testHubProvider,
          child: child,
        ),
      );

  // Setup is called before each test is run
  setUp(() async {
    mockHubServices = MockHubServices();
    testHubProvider = HubProvider(mockHubServices);

    when(mockHubServices.fetchAllHubs()).thenAnswer(
        (_) => Future.value([getHubDetails(), getHubDetails("Test Hub")]));
    await testHubProvider.fetchAllHubs();
    expect(testHubProvider.hubs.data.length, 2);
  });

  testWidgets("test data displayed", (tester) async {
    mockNetworkImagesFor(() async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(
          makeTestableWidget(child: const SearchScreen(selectedHubName: "")));

      final hubDetailsVerticalCards = find.byType(HubDetailsVerticalCard);
      await tester.pump(const Duration(milliseconds: 500));
      expect(hubDetailsVerticalCards, findsNWidgets(2));

      await tester.pumpAndSettle();
    });
  });

  testWidgets("test filtered data displayed - 1", (tester) async {
    mockNetworkImagesFor(() async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(makeTestableWidget(
          child: const SearchScreen(selectedHubName: "Test")));

      final hubDetailsVerticalCards = find.byType(HubDetailsVerticalCard);
      await tester.pump(const Duration(milliseconds: 500));
      expect(hubDetailsVerticalCards, findsNWidgets(1));

      await tester.pumpAndSettle();
    });
  });

  testWidgets("test filtered data displayed - 2", (tester) async {
    mockNetworkImagesFor(() async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(makeTestableWidget(
          child: const SearchScreen(selectedHubName: "hub")));

      final hubDetailsVerticalCards = find.byType(HubDetailsVerticalCard);
      await tester.pump(const Duration(milliseconds: 500));
      expect(hubDetailsVerticalCards, findsNWidgets(2));

      await tester.pumpAndSettle();
    });
  });
}
