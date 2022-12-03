import 'package:flutter/material.dart';
import 'package:hawker_hub/utilities/constants.dart';
import 'package:hawker_hub/widgets/hub_details_base_card.dart';

// TODO: Update hardcoded data to receive values from network call
class HubDetailsVerticalCard extends HubDetailsBaseCard {
  HubDetailsVerticalCard({super.key});

  final Widget _hubImage = Image.network(
    'https://source.unsplash.com/user/c_v_r/150x150',
    width: 600,
    height: 240,
    fit: BoxFit.fill,
  );

  final Widget _hubCardButtonRow = Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        OutlinedButton(onPressed: () => {}, child: const Text("Suggest Edit")),
        ElevatedButton(onPressed: () => {}, child: const Text("Get Direction"))
      ],
    ),
  );

  Widget _hubTitleRow(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            hubRating(context),
            hubTitle(context),
            Icon(Icons.thumb_up_alt_outlined, color: Colors.grey[500]),
          ],
        ),
      );

  Widget _hubDescription(BuildContext context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Open Now",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              "Timings\nMonday: 10:00AM - 12:00PM\nMonday: 10:00AM - 12:00PM\nMonday: 10:00AM - 12:00PM\nMonday: 10:00AM - 12:00PM\nMonday: 10:00AM - 12:00PM\nMonday: 10:00AM - 12:00PM\n",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              "DesiPDX is a food cart on Mississippi Avenue serving Local Fare with Indian Flair. 100% Gluten Free with Paleo & Vegan Options.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            _hubCardButtonRow
          ],
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: DesignConstants.hubDetailsCardShape(context),
        child: Column(
          children: [
            _hubTitleRow(context),
            _hubImage,
            _hubDescription(context),
          ],
        ));
  }
}
