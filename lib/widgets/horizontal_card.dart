import 'package:flutter/material.dart';

class HorizontalCard extends StatelessWidget {
  const HorizontalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
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
                              fontStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.fontStyle,
                              color: Colors.white)))),
              Expanded(
                /*1*/
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*2*/
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
              ),
              Column(
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
              ),
            ],
          ),
        ));
  }
}
