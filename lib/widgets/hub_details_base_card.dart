import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:intl/intl.dart';

abstract class HubDetailsBaseCard extends StatelessWidget {
  const HubDetailsBaseCard({super.key});

  final heightSpacer = const SizedBox(height: 10);

  bool isOpen(String startTimeString, String endTimeString) {
    try {
      // Get the current time
      DateTime currentDateTime = clock.now();

      // Appending current date to start and end time for comparison
      String currentDate = DateFormat('yyyy-MM-dd').format(currentDateTime);
      DateTime startTime =
          DateFormat('yyyy-MM-dd hh:mm').parse("$currentDate $startTimeString");
      DateTime endTime =
          DateFormat('yyyy-MM-dd hh:mm').parse("$currentDate $endTimeString");

      // Check if the current time is between the start time and the end time
      if (currentDateTime.isAfter(startTime) &&
          currentDateTime.isBefore(endTime)) {
        return true;
      }
    } catch (exeption) {
      return false;
    }

    return false;
  }

  Widget getHubStatus(
      BuildContext context, Hub hubDetails, int hubLocationArrayIndex) {
    if (isOpen(hubDetails.hubLocations[hubLocationArrayIndex].hubStartTime,
        hubDetails.hubLocations[hubLocationArrayIndex].hubEndTime)) {
      return Text("OPEN",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: Theme.of(context).textTheme.headlineSmall?.fontStyle,
              color: Colors.green));
    }
    return Text("CLOSED",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: Theme.of(context).textTheme.headlineSmall?.fontStyle,
            color: Colors.redAccent));
  }

  String hubTimingsStringFormart(Hub hubDetails, int hubLocationArrayIndex) {
    const String newLine = "\n";
    const String tabSpace = "\t";
    String formattedString = "Timings:$newLine";

    List<String> hubDaysOfOperation =
        hubDetails.hubLocations[hubLocationArrayIndex].hubDaysOfOperation;
    String hubStartTime =
        hubDetails.hubLocations[hubLocationArrayIndex].hubStartTime;
    String hubEndTime =
        hubDetails.hubLocations[hubLocationArrayIndex].hubEndTime;

    for (String day in hubDaysOfOperation) {
      formattedString +=
          "$day$tabSpace:$tabSpace$hubStartTime - $hubEndTime$newLine";
    }

    return formattedString;
  }

  Widget hubRating(BuildContext context, double rating) => Container(
      margin: const EdgeInsets.only(right: 20),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Text(rating.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: Theme.of(context).textTheme.labelLarge?.fontStyle,
                  color: Colors.white))));

  Widget hubTitle(BuildContext context, String title, String category) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              category,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );

  Widget hubAddress(BuildContext context, String address) => Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            address,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          ElevatedButton(
              onPressed: () => {}, child: const Text("Get Direction"))
        ],
      ));
}
