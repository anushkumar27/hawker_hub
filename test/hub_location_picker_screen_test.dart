import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawker_hub/providers/hub_provider.dart';
import 'package:hawker_hub/screens/hub_location_picker_screen.dart';
import 'package:hawker_hub/services/hub_services.dart';
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'hub_provider_test.mocks.dart';

@GenerateMocks([HubServices])
void main() {
  late HubServices mockHubServices;
  late HubProvider testHubProvider;

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
  });

  testWidgets("test data displayed", (tester) async {
    mockNetworkImagesFor(() async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(makeTestableWidget(
          child: HubLocationPickerScreen(
              hubLocationIndex: 0,
              setHubAddressAndGeoLocationCallback: () {})));

      final googleMapWidget = find.byType(GoogleMap);
      expect(googleMapWidget, findsOneWidget);

      final addressCardWidget = find.byType(Card);
      expect(addressCardWidget, findsOneWidget);

      final locationPickerImageWidget = find.byType(Image);
      expect(locationPickerImageWidget, findsNWidgets(2));
    });
  });
}
