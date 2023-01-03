import 'package:flutter/material.dart';

abstract class HubDetailsBaseCard extends StatelessWidget {
  const HubDetailsBaseCard({super.key});

  final heightSpacer = const SizedBox(height: 10);

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

  // TODO: Add Open Status
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
