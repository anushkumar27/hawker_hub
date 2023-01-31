import 'package:flutter/material.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/providers/hub_provider.dart';
import 'package:hawker_hub/services/api_response.dart';
import 'package:hawker_hub/utilities/constants.dart';
import 'package:hawker_hub/widgets/hub_details_vertical_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.selectedHubName});

  final String? selectedHubName;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchFieldTextController;
  String _searchFieldString = "";

  @override
  void initState() {
    super.initState();
    _searchFieldTextController = TextEditingController();
    _searchFieldTextController.addListener(_updateLatestSearchFieldString);

    _searchFieldTextController.text = widget.selectedHubName!;
    _searchFieldString = _searchFieldTextController.text;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _searchFieldTextController.dispose();
    super.dispose();
  }

  void _updateLatestSearchFieldString() {
    setState(() {
      _searchFieldString = _searchFieldTextController.text;
    });
  }

  Widget _searchTextFieldContainer(BuildContext context) => TextField(
      controller: _searchFieldTextController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: "Name, Category, Food trucks..",
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
        labelText: 'Search',
      ));

  final heightSpacer = const SizedBox(height: 15);

  List<HubDetailsVerticalCard> getFilteredHubDetailsVerticalCardList(
      List<Hub> hubList) {
    List<HubDetailsVerticalCard> hubDetailsVerticalCardList = [];
    for (Hub hub in hubList) {
      for (HubLocation hubLocation in hub.hubLocations) {
        if (hub.hubName
            .toLowerCase()
            .contains(_searchFieldString.toLowerCase())) {
          hubDetailsVerticalCardList.add(HubDetailsVerticalCard(
              hubDetails: hub,
              hubLocationArrayIndex: hub.hubLocations.indexOf(hubLocation)));
        }
      }
    }

    return hubDetailsVerticalCardList;
  }

  Widget _showSearchResults(
      BuildContext context, ApiResponse<List<Hub>> hubDetails) {
    switch (hubDetails.requestStatus) {
      case RequestStatus.loading:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Fetching Data"),
              SizedBox(width: 20),
              CircularProgressIndicator()
            ]);
      case RequestStatus.completed:
        List<Hub> hubList = hubDetails.data;
        return Column(children: getFilteredHubDetailsVerticalCardList(hubList));
      case RequestStatus.error:
        return Center(
          child: Text(hubDetails.statusMessage),
        );
      default:
        return const Center(
          child: Text('There are no Hubs in the area'),
        );
    }
  }

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
                        heightSpacer,
                        _searchTextFieldContainer(context),
                        heightSpacer,
                        Consumer<HubProvider>(
                            builder: (context, hubDetails, child) =>
                                _showSearchResults(context, hubDetails.hubs)),
                      ]),
                    )))));
  }
}
