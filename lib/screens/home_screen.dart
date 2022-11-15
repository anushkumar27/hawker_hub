import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawker_hub/widgets/hub_details_horizontal_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// TODO: Update hardcoded data to receive values from network call
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double _initialContributeButtonHeight = 100.0;
  final double _minExplorePanelHeight = 95.0;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  final _explorePanelMargins = const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0);
  final _explorePanelDrawerIndication = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        width: 30,
        height: 5,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.all(Radius.circular(12.0))),
      ),
    ],
  );
  final _explorePanelPaddingBox = const SizedBox(
    height: 18.0,
  );

  double _currentContributeButtonHeight = 0;
  double _maxExplorePanelHeight = 0;
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _updateContributeButtonPosition(double position) => setState(() {
        _currentContributeButtonHeight =
            position * (_maxExplorePanelHeight - _minExplorePanelHeight) +
                _initialContributeButtonHeight;
      });

  @override
  void initState() {
    super.initState();

    _currentContributeButtonHeight = _initialContributeButtonHeight;
  }

  Widget _explorePanel(BuildContext context) => SlidingUpPanel(
        maxHeight: _maxExplorePanelHeight,
        minHeight: _minExplorePanelHeight,
        parallaxEnabled: true,
        parallaxOffset: .5,
        renderPanelSheet: false,
        panel: _explorePanelBody(context),
        collapsed: _explorePanelCollapsed(context),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        onPanelSlide: _updateContributeButtonPosition,
      );

  Widget _contributeButton(BuildContext context) => Positioned(
        right: 20.0,
        bottom: _currentContributeButtonHeight,
        child: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          label: const Text('Contribute'),
          icon: const Icon(Icons.add),
        ),
      );

  Widget _searchTextFieldContainer(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: const TextField(
            autofocus: false,
            decoration: InputDecoration(
              hintText: "Name, Category, Food trucks..",
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.cancel_outlined),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              labelText: 'Search',
            )),
      );

  @override
  Widget build(BuildContext context) {
    _maxExplorePanelHeight = MediaQuery.of(context).size.height * .50;
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        _explorePanel(context),
        _contributeButton(context),
        _searchTextFieldContainer(context)
      ],
    );
  }

  BoxDecoration _explorePanelDecoration(BuildContext context) => BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10.0,
              color: Colors.grey,
            ),
          ]);

  Widget _explorePanelCollapsed(BuildContext context) {
    return Container(
      decoration: _explorePanelDecoration(context),
      margin: _explorePanelMargins,
      child: Center(
          child: Text("Explore Hubs",
              style: Theme.of(context).textTheme.headlineSmall)),
    );
  }

  Widget _explorePanelBody(BuildContext context) {
    return Container(
      decoration: _explorePanelDecoration(context),
      margin: _explorePanelMargins,
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
      child: Center(
          child: ListView(
        children: <Widget>[
          _explorePanelDrawerIndication,
          _explorePanelPaddingBox,
          for (int i = 0; i < 6; i++) ...[const HubDetailsHorizontalCard()],
        ],
      )),
    );
  }
}
