import 'package:flutter/material.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/utilities/constants.dart';
import 'package:hawker_hub/widgets/hub_details_base_card.dart';

// TODO: Update hardcoded data to receive values from network call
class HubDetailsHorizontalCard extends HubDetailsBaseCard {
  const HubDetailsHorizontalCard({super.key, required this.hubDetails});

  final Hub hubDetails;

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

  @override
  Widget build(BuildContext context) {
    // TODO: Take care of multiple locations
    return Card(
        shape: DesignConstants.hubDetailsCardShape(context),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              hubRating(context, hubDetails.hubRating),
              hubTitle(context, hubDetails.hubName, hubDetails.hubCategory),
              _hubTimings(context, hubDetails.hubLocations[0].hubStartTime,
                  hubDetails.hubLocations[0].hubEndTime)
            ],
          ),
        ));
  }
}
