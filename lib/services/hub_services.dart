import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/services/http_client.dart';

/// Hub Services
/// Holds all the REST services realated to Hubs
class HubServices {
  Future<List<Hub>> fetchAllHubs() async {
    List<Hub> hubs = [];
    final response = await HttpClient.instance.fetchData();
    for (Map<String, dynamic> hub in response) {
      hubs.add(Hub.fromJson(hub));
    }
    return hubs;
  }
}
