import 'package:flutter/material.dart';

class VerticalCard extends StatelessWidget {
  const VerticalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: [
            Padding(
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
                          "Food",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.thumb_up_alt_outlined, color: Colors.grey[500]),
                ],
              ),
            ),
            Image.network(
              'https://via.placeholder.com/150',
              width: 600,
              height: 240,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    /*1*/
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*2*/
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              OutlinedButton(
                                  onPressed: () => {},
                                  child: const Text("Suggest Edit")),
                              ElevatedButton(
                                  onPressed: () => {},
                                  child: const Text("Get Direction"))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
