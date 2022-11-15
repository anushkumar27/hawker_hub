import 'package:flutter/material.dart';

abstract class HubDetailsBaseCard extends StatelessWidget {
  const HubDetailsBaseCard({super.key});

  Widget hubRating(BuildContext context) => Container(
      margin: const EdgeInsets.only(right: 20),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Text("4.1",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: Theme.of(context).textTheme.labelLarge?.fontStyle,
                  color: Colors.white))));

  Widget hubTitle(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "La Raquita",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Food | Open Now",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
}
