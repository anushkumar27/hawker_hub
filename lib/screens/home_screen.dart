import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double _initFabHeight = 100.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  final double _panelHeightClosed = 95.0;

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();

    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .50;
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            renderPanelSheet: false,
            panel: _floatingPanel(context),
            collapsed: _floatingCollapsed(context),
            body: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
            onPanelSlide: (double pos) => setState(() {
                  _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                      _initFabHeight;
                })),
        Positioned(
          right: 20.0,
          bottom: _fabHeight,
          child: FloatingActionButton.extended(
            onPressed: () {
              // Add your onPressed code here!
            },
            label: const Text('Contribute'),
            icon: const Icon(Icons.add),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          child: const TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: "Name, Category, Food trucks..",
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.cancel_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                labelText: 'Search',
              )),
        )
      ],
    );
  }

  Widget _floatingCollapsed(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: Center(
          child: Text("Explore Hubs",
              style: Theme.of(context).textTheme.headlineSmall)),
    );
  }

  Widget _floatingPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10.0,
              color: Colors.grey,
            ),
          ]),
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
      child: Center(
          child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          const SizedBox(
            height: 18.0,
          ),
          for (int i = 0; i < 6; i++) ...[
            Card(
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
                )),
          ],
        ],
      )),
    );
  }
}
