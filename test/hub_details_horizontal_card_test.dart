import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/providers/hub_provider.dart';
import 'package:hawker_hub/services/hub_services.dart';
import 'package:hawker_hub/utilities/constants.dart';
import 'package:hawker_hub/widgets/hub_details_horizontal_card.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'hub_provider_test.mocks.dart';

@GenerateMocks([HubServices])
void main() {
  late HubServices mockHubServices;
  late HubProvider testHubProvider;

  Hub getStaticHubDetails() {
    return Hub(
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
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(makeTestableWidget(
        child: HubDetailsHorizontalCard(
            hubDetails: getStaticHubDetails(), hubLocationArrayIndex: 0)));

    final hubTitle = find.text(getStaticHubDetails().hubName);
    final hubCategory = find.text(getStaticHubDetails().hubCategory);
    final hubAddress =
        find.text(getStaticHubDetails().hubLocations[0].hubAddress);
    final hubStartTime =
        find.text(getStaticHubDetails().hubLocations[0].hubStartTime);
    final hubEndTime =
        find.text(getStaticHubDetails().hubLocations[0].hubEndTime);

    expect(hubTitle, findsOneWidget);
    expect(hubCategory, findsOneWidget);
    expect(hubAddress, findsOneWidget);
    expect(hubStartTime, findsOneWidget);
    expect(hubEndTime, findsOneWidget);
  });

  testWidgets("test active card style", (tester) async {
    // Make an active selection
    testHubProvider.setSelectedHubIdAndLocationArrayIndex(
        getStaticHubDetails().hubId, 0);
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(makeTestableWidget(
        child: HubDetailsHorizontalCard(
            hubDetails: getStaticHubDetails(), hubLocationArrayIndex: 0)));

    final hubCard = find.byType(Card);
    final BuildContext context = tester.element(hubCard);
    final renderedHubCard = tester.firstWidget<Card>(hubCard);

    await tester.pump(const Duration(milliseconds: 500));
    expect(renderedHubCard.shape,
        DesignConstants.hubDetailsSelectedCardShape(context));

    await tester.pumpAndSettle();
  });

  testWidgets("test non-active card style", (tester) async {
    // Make an active selection
    testHubProvider.setSelectedHubIdAndLocationArrayIndex("123", 0);
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(makeTestableWidget(
        child: HubDetailsHorizontalCard(
            hubDetails: getStaticHubDetails(), hubLocationArrayIndex: 0)));

    final hubCard = find.byType(Card);
    final BuildContext context = tester.element(hubCard);
    final renderedHubCard = tester.firstWidget<Card>(hubCard);

    await tester.pump(const Duration(milliseconds: 500));
    expect(renderedHubCard.shape, DesignConstants.hubDetailsCardShape(context));

    await tester.pumpAndSettle();
  });
}
