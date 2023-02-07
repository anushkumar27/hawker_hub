import 'package:flutter/material.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/screens/update_screen.dart';
import 'package:hawker_hub/utilities/constants.dart';
import 'package:hawker_hub/widgets/hub_details_base_card.dart';
import 'package:url_launcher/url_launcher.dart';

class HubDetailsVerticalCard extends HubDetailsBaseCard {
  const HubDetailsVerticalCard(
      {super.key,
      required this.hubDetails,
      required this.hubLocationArrayIndex});

  final Hub hubDetails;
  final int hubLocationArrayIndex;

  Widget _hubImage(String hubPhotoURL) => Image.network(
        hubPhotoURL,
        width: 600,
        height: 240,
        fit: BoxFit.fill,
      );

  Future<void> _launchDirectionToHub() async {
    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=${hubDetails.hubLocations[hubLocationArrayIndex].hubLatitude},${hubDetails.hubLocations[hubLocationArrayIndex].hubLongitude}";

    final Uri encodedURI = Uri.parse(googleMapslocationUrl);
    if (!await launchUrl(encodedURI)) {
      throw 'Could not launch $encodedURI';
    }
  }

  Widget _hubCardButtonRow(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          OutlinedButton(
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateScreen(
                                  oldHub: hubDetails,
                                ))),
                  },
              child: const Text("Suggest Edit")),
          ElevatedButton(
              onPressed: _launchDirectionToHub,
              child: const Text("Get Direction"))
        ],
      );

  Widget _hubTitleRow(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            hubRating(context, hubDetails.hubRating),
            hubTitle(context, hubDetails.hubName, hubDetails.hubCategory),
            Icon(Icons.thumb_up_alt_outlined, color: Colors.grey[500]),
          ],
        ),
      );

  Widget _hubDescription(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHubStatus(context, hubDetails, hubLocationArrayIndex),
            heightSpacer,
            Text(
              hubTimingsStringFormart(hubDetails, hubLocationArrayIndex),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            heightSpacer,
            Text(
              hubDetails.hubDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            heightSpacer,
            _hubCardButtonRow(context)
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: DesignConstants.hubDetailsCardShape(context),
        child: Column(
          children: [
            _hubTitleRow(context),
            _hubImage(hubDetails.hubPhoto),
            _hubDescription(context),
          ],
        ));
  }
}
