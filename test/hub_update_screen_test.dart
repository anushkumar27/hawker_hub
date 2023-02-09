import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/providers/hub_provider.dart';
import 'package:hawker_hub/screens/update_screen.dart';
import 'package:hawker_hub/services/hub_services.dart';
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
  late Hub testHub;

  Hub getHubDetails([String? hubName]) {
    return Hub(
        hubId: uuidGenerator.v4(),
        hubRating: 4.5,
        hubPhoto: "RANDOM_URL",
        hubName: hubName ?? "Mock Hub",
        hubDescription: "Mock Hub Description",
        hubCategory: "Other",
        hubCostForTwo: "99",
        hubLocations: const [
          HubLocation(
              hubAddress: "Mock Hub Address 1",
              hubDaysOfOperation: ["Monday"],
              hubEndTime: "15:00",
              hubStartTime: "10:00",
              hubPhoneNumber: "123456789",
              hubLatitude: 141.1234,
              hubLongitude: 142.4321),
          HubLocation(
              hubAddress: "Mock Hub Address 2",
              hubDaysOfOperation: ["Monday", "Sunday"],
              hubEndTime: "20:00",
              hubStartTime: "07:00",
              hubPhoneNumber: "99999999",
              hubLatitude: 156.7894564123,
              hubLongitude: 156.2316546545)
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
    testHub = getHubDetails();

    when(mockHubServices.fetchAllHubs())
        .thenAnswer((_) => Future.value([testHub]));
    await testHubProvider.fetchAllHubs();
    expect(testHubProvider.hubs.data.length, 1);
  });

  testHubLocationFormFields(int index, Matcher matcher) {
    var formField = find.byKey(Key("hub_address_$index"));
    expect(formField, matcher);

    formField = find.byKey(Key("hub_address_lat_$index"));
    expect(formField, matcher);

    formField = find.byKey(Key("hub_address_long_$index"));
    expect(formField, matcher);

    formField = find.byKey(Key("hub_phone_number_$index"));
    expect(formField, matcher);

    formField = find.byKey(Key("hub_days_of_operation_$index"));
    expect(formField, matcher);

    formField = find.byKey(Key("hub_start_time_$index"));
    expect(formField, matcher);

    formField = find.byKey(Key("hub_end_time_$index"));
    expect(formField, matcher);
  }

  testWidgets("test data displayed", (tester) async {
    mockNetworkImagesFor(() async {
      // Create the widget by telling the tester to build it.
      await tester
          .pumpWidget(makeTestableWidget(child: UpdateScreen(oldHub: testHub)));
      await tester.pumpAndSettle();

      final formRatingBar = find.byType(FormBuilderRatingBar);
      expect(formRatingBar, findsNWidgets(1));

      final formImagePicker = find.byType(FormBuilderImagePicker);
      expect(formImagePicker, findsNWidgets(1));

      final formDropdown = find.byType(FormBuilderDropdown<String>);
      expect(formDropdown, findsNWidgets(1));

      testHubLocationFormFields(0, findsOneWidget);
      testHubLocationFormFields(1, findsOneWidget);
      testHubLocationFormFields(2, findsNothing);

      await tester.pumpAndSettle();
    });
  });
}
