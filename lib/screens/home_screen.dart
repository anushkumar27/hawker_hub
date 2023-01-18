import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/providers/hub_provider.dart';
import 'package:hawker_hub/screens/search_screen.dart';
import 'package:hawker_hub/screens/contribute_screen.dart';
import 'package:hawker_hub/services/api_response.dart';
import 'package:hawker_hub/widgets/hub_details_horizontal_card.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  final _explorePanelDrawerIndicator = Row(
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

  // TODO: Move map to user's current location
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

    // Get all the hubs
    Provider.of<HubProvider>(context, listen: false).fetchAllHubs();
  }

  Set<Marker> getHubMarkers(ApiResponse<List<Hub>> hubDetails) {
    Set<Marker> markers = {};
    if (hubDetails.requestStatus != RequestStatus.completed) return markers;

    for (Hub hub in hubDetails.data) {
      hub.hubLocations.asMap().forEach((index, hubLocation) => markers.add(
          Marker(
              // Index is appended as one hub can have multiple locations
              markerId: MarkerId(hub.hubId + index.toString()),
              position:
                  LatLng(hubLocation.hubLatitude, hubLocation.hubLogitude),
              infoWindow: InfoWindow(
                title: "${hub.hubName} (${hub.hubRating})",
                snippet: hubLocation.hubAddress,
              ))));
    }

    return markers;
  }

  Widget _explorePanel(
          BuildContext context, ApiResponse<List<Hub>> hubDetails) =>
      SlidingUpPanel(
        maxHeight: _maxExplorePanelHeight,
        minHeight: _minExplorePanelHeight,
        parallaxEnabled: true,
        parallaxOffset: .5,
        renderPanelSheet: false,
        panel: _explorePanelBody(context, hubDetails),
        collapsed: _explorePanelCollapsed(context),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: getHubMarkers(hubDetails),
        ),
        onPanelSlide: _updateContributeButtonPosition,
      );

  Widget _contributeButton(BuildContext context) => Positioned(
        right: 20.0,
        bottom: _currentContributeButtonHeight,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContributeScreen()),
            );
          },
          label: const Text('Contribute'),
          icon: const Icon(Icons.add),
        ),
      );

  Widget _searchTextFieldContainer(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: TextField(
            autofocus: false,
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SearchScreen(selectedHubName: "")),
                ),
            decoration: const InputDecoration(
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
        Consumer<HubProvider>(
            builder: (context, hubDetails, child) =>
                _explorePanel(context, hubDetails.hubs)),
        _contributeButton(context),
        _searchTextFieldContainer(context),
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

  List<HubDetailsHorizontalCard> getHubDetailsHorizontalCardList(
      List<Hub> hubList) {
    List<HubDetailsHorizontalCard> hubDetailsHorizontalCardList = [];
    for (Hub hub in hubList) {
      for (HubLocation hubLocation in hub.hubLocations) {
        hubDetailsHorizontalCardList.add(HubDetailsHorizontalCard(
          hubDetails: hub,
          hubLocationArrayIndex: hub.hubLocations.indexOf(hubLocation),
          mapController: mapController,
        ));
      }
    }

    return hubDetailsHorizontalCardList;
  }

  Widget _explorePanelHubDetails(ApiResponse<List<Hub>> hubDetails) {
    switch (hubDetails.requestStatus) {
      case RequestStatus.loading:
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Fetching Data"),
              SizedBox(width: 20),
              CircularProgressIndicator()
            ]);
      case RequestStatus.completed:
        List<Hub> hubList = hubDetails.data;
        return Column(children: getHubDetailsHorizontalCardList(hubList));
      case RequestStatus.error:
        return Center(
          child: Text(hubDetails.statusMessage),
        );
      default:
        return const Center(
          child: Text('There are no Hubs in the area'),
        );
    }
  }

  Widget _explorePanelBody(
      BuildContext context, ApiResponse<List<Hub>> hubDetails) {
    return Container(
      decoration: _explorePanelDecoration(context),
      margin: _explorePanelMargins,
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
      child: Center(
          child: ListView(
        children: <Widget>[
          _explorePanelDrawerIndicator,
          _explorePanelPaddingBox,
          _explorePanelHubDetails(hubDetails),
        ],
      )),
    );
  }
}
