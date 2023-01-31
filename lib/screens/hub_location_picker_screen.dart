import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawker_hub/utilities/constants.dart';
import 'package:location/location.dart';

class HubLocationPickerScreen extends StatefulWidget {
  const HubLocationPickerScreen(
      {super.key,
      required this.hubLocationIndex,
      required this.setHubAddressAndGeoLocationCallback});

  final int hubLocationIndex;
  final dynamic setHubAddressAndGeoLocationCallback;

  @override
  State<HubLocationPickerScreen> createState() =>
      _HubLocationPickerScreenState();
}

class _HubLocationPickerScreenState extends State<HubLocationPickerScreen> {
  // Location service
  final Location _locationService = Location();
  // Google maps controller
  GoogleMapController? mapController;
  // Current maps camera position
  CameraPosition? currentCameraPosition;
  // Initial center of the map
  final LatLng _center = const LatLng(45.521563, -122.677433);
  // Picker image
  static const String pickerImagePath = "lib/assets/picker.png";

  // Stores current location co-ordinates and address
  String currentLocationAddress = "";
  LatLng currentLocation = const LatLng(45.521563, -122.677433);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    // Move map to user's current location
    final latestCurrentLocation = await _locationService.getLocation();
    currentLocation = LatLng(
        latestCurrentLocation.latitude!, latestCurrentLocation.longitude!);
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLocation, zoom: 15),
      ),
    );
  }

  _onCameraIdle() async {
    // When the Map drag stops, get place details from current position
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentCameraPosition!.target.latitude,
        currentCameraPosition!.target.longitude);
    // Update state and set details via call back
    setState(() {
      Placemark placeMark = placemarks.first;
      String? street = placeMark.street;
      String? locality = placeMark.locality;
      String? administrativeArea = placeMark.administrativeArea;
      String? postalCode = placeMark.postalCode;
      String? country = placeMark.country;

      // Get address from current latitude and longitude
      currentLocation = LatLng(currentCameraPosition!.target.latitude,
          currentCameraPosition!.target.longitude);
      currentLocationAddress =
          "$street, $locality, $administrativeArea $postalCode, $country";
      widget.setHubAddressAndGeoLocationCallback(
          widget.hubLocationIndex,
          currentLocationAddress,
          currentLocation.latitude,
          currentLocation.longitude);
    });
  }

  _addressDisplayCard(BuildContext context) => Positioned(
        // Widget to display location name
        bottom: 100,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Card(
            child: Container(
                padding: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width - 40,
                child: ListTile(
                  leading: Image.asset(
                    pickerImagePath,
                    width: 25,
                  ),
                  title: Text(
                    currentLocationAddress,
                    style: const TextStyle(fontSize: 12),
                  ),
                  dense: true,
                )),
          ),
        ),
      );

  final _pickerImage = Center(
    // Picker image on google map
    child: Image.asset(
      pickerImagePath,
      width: 50,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
            child: Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Contribute")),
        backgroundColor: Constants.primarySurfaceColor,
      ),
      body: Stack(children: [
        GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.0,
          ),
          onMapCreated: _onMapCreated,
          onCameraMove: (CameraPosition newCameraPosition) {
            // When the Map is dragged
            currentCameraPosition = newCameraPosition;
          },
          onCameraIdle: _onCameraIdle,
        ),
        // Picker Image at the centre
        _pickerImage,
        _addressDisplayCard(context)
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (currentLocationAddress == "") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Error getting the address!'),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: _onCameraIdle,
                ),
              ),
            );
          } else {
            Navigator.pop(context);
          }
        },
        label: const Text('Done'),
        icon: const Icon(Icons.done),
      ),
    )));
  }
}
