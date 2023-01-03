import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/screens/search_screen.dart';
import 'package:hawker_hub/utilities/constants.dart';
import 'package:hawker_hub/widgets/hub_details_base_card.dart';
import 'package:url_launcher/url_launcher.dart';

class HubDetailsHorizontalCard extends HubDetailsBaseCard {
  const HubDetailsHorizontalCard(
      {super.key,
      required this.hubDetails,
      required this.hubLocationArrayIndex,
      this.mapController});

  final Hub hubDetails;
  final int hubLocationArrayIndex;
  final GoogleMapController? mapController;

  Widget _hubTimings(BuildContext context, String startTime, String endTime) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            startTime,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          Text(
            "to",
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          Text(
            endTime,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      );

  moveToHubMarker() {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
                hubDetails.hubLocations[hubLocationArrayIndex].hubLatitude,
                hubDetails.hubLocations[hubLocationArrayIndex].hubLogitude),
            zoom: 15)
        //17 is new zoom level
        ));
  }

  Future<void> _launchDirectionToHub() async {
    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=${hubDetails.hubLocations[hubLocationArrayIndex].hubLatitude},${hubDetails.hubLocations[hubLocationArrayIndex].hubLogitude}";

    final Uri encodedURI = Uri.parse(googleMapslocationUrl);
    if (!await launchUrl(encodedURI)) {
      throw 'Could not launch $encodedURI';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: moveToHubMarker,
      child: Card(
          shape: DesignConstants.hubDetailsCardShape(context),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    hubRating(context, hubDetails.hubRating),
                    hubTitle(
                      context,
                      hubDetails.hubName,
                      hubDetails.hubCategory,
                    ),
                    _hubTimings(
                        context,
                        hubDetails
                            .hubLocations[hubLocationArrayIndex].hubStartTime,
                        hubDetails
                            .hubLocations[hubLocationArrayIndex].hubEndTime),
                  ],
                ),
                heightSpacer,
                Text(
                  hubDetails.hubLocations[hubLocationArrayIndex].hubAddress,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                heightSpacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    OutlinedButton(
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen(
                                      selectedHubName: hubDetails.hubName)),
                            ),
                        child: const Text("More Information")),
                    ElevatedButton(
                        onPressed: _launchDirectionToHub,
                        child: const Text("Get Direction"))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
