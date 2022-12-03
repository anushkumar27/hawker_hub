import 'package:flutter/material.dart';
import 'package:hawker_hub/utilities/constants.dart';
import 'package:hawker_hub/widgets/hub_details_vertical_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  Widget _searchTextFieldContainer(BuildContext context) => const TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Name, Category, Food trucks..",
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.cancel_outlined),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
        labelText: 'Search',
      ));

  final heightSpacer = const SizedBox(height: 15);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
            child: Scaffold(
                appBar: AppBar(
                  title: const Center(child: Text("Hub Search")),
                  backgroundColor: Constants.primarySurfaceColor,
                ),
                body: Container(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        _searchTextFieldContainer(context),
                        heightSpacer,
                        for (int i = 0; i < 2; i++) ...[
                          HubDetailsVerticalCard()
                        ],
                      ]),
                    )))));
  }
}
