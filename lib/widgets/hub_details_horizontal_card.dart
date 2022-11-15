import 'package:flutter/material.dart';
import 'package:hawker_hub/utilities/constants.dart';
import 'package:hawker_hub/widgets/hub_details_base_card.dart';

// TODO: Update hardcoded data to receive values from network call
class HubDetailsHorizontalCard extends HubDetailsBaseCard {
  const HubDetailsHorizontalCard({super.key});

  Widget _hubTimings(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "10:00 AM",
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
            "12:00 PM",
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: DesignConstants.hubDetailsCardShape(context),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              hubRating(context),
              hubTitle(context),
              _hubTimings(context)
            ],
          ),
        ));
  }
}
