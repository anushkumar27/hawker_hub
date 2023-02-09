import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/providers/hub_provider.dart';
import 'package:hawker_hub/services/hub_services.dart';
import 'package:hawker_hub/widgets/hub_details_vertical_card.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'hub_provider_test.mocks.dart';
import 'package:clock/clock.dart';

@GenerateMocks([HubServices])
void main() {
  late HubServices mockHubServices;
  late HubProvider testHubProvider;

  Hub getStaticHubDetails() {
    return const Hub(
        hubId: "ec20da91-1ddc-44f6-a0f4-ec3102608d98",
        hubRating: 4.5,
        hubPhoto: "RANDOM_URL",
        hubName: "Mock Hub",
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
          child: Scaffold(
            body: child,
          ),
        ),
      );

  // Setup is called before each test is run
  setUp(() async {
    mockHubServices = MockHubServices();
    testHubProvider = HubProvider(mockHubServices);

    when(mockHubServices.fetchAllHubs())
        .thenAnswer((_) => Future.value([getStaticHubDetails()]));
    await testHubProvider.fetchAllHubs();
    expect(testHubProvider.hubs.data.length, greaterThanOrEqualTo(1));
  });

  testWidgets("test data displayed", (tester) async {
    mockNetworkImagesFor(() async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(makeTestableWidget(
          child: HubDetailsVerticalCard(
              hubDetails: getStaticHubDetails(), hubLocationArrayIndex: 0)));
      await tester.pump(const Duration(milliseconds: 500));

      final hubTitle = find.text(getStaticHubDetails().hubName);
      final hubRating = find.text(getStaticHubDetails().hubRating.toString());
      final hubCategory = find.text(getStaticHubDetails().hubCategory);
      final hubDescription = find.text(getStaticHubDetails().hubDescription);
      final hubTimmings = find.textContaining(
          getStaticHubDetails().hubLocations[0].hubDaysOfOperation[0]);
      expect(hubTitle, findsOneWidget);
      expect(hubRating, findsOneWidget);
      expect(hubCategory, findsOneWidget);
      expect(hubDescription, findsOneWidget);
      expect(hubTimmings, findsOneWidget);
    });
  });

  testWidgets("test open status", (tester) async {
    withClock(
      Clock.fixed(DateFormat('yyyy-MM-dd hh:mm').parse("1996-01-01 13:00")),
      () {
        mockNetworkImagesFor(() async {
          // Create the widget by telling the tester to build it.
          await tester.pumpWidget(makeTestableWidget(
              child: HubDetailsVerticalCard(
                  hubDetails: getStaticHubDetails(),
                  hubLocationArrayIndex: 0)));
          await tester.pump(const Duration(milliseconds: 500));

          final hubOpenStatus = find.text("OPEN");
          expect(hubOpenStatus, findsOneWidget);
        });
      },
    );
  });

  testWidgets("test closed status", (tester) async {
    withClock(
      Clock.fixed(DateFormat('yyyy-MM-dd hh:mm').parse("1996-01-01 07:00")),
      () {
        mockNetworkImagesFor(() async {
          // Create the widget by telling the tester to build it.
          await tester.pumpWidget(makeTestableWidget(
              child: HubDetailsVerticalCard(
                  hubDetails: getStaticHubDetails(),
                  hubLocationArrayIndex: 0)));
          await tester.pump(const Duration(milliseconds: 500));

          final hubOpenStatus = find.text("CLOSED");
          expect(hubOpenStatus, findsOneWidget);
        });
      },
    );
  });
}
