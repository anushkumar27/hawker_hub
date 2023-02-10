import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/services/http_client.dart';
import 'package:image_picker/image_picker.dart';

/// Hub Services
/// Holds all the REST services realated to Hubs
class HubServices {
  late HttpClient _httpClient;

  HubServices(HttpClient httpClient) {
    _httpClient = httpClient;
  }

  Future<List<Hub>> fetchAllHubs() async {
    List<Hub> hubs = [];
    final response = await _httpClient.fetchData();
    for (Map<String, dynamic> hub in response) {
      hubs.add(Hub.fromJson(hub));
    }
    return hubs;
  }

  Future<Hub> insertHub(Hub hubDetails, XFile hubPhoto) async {
    final response =
        await _httpClient.sendDataAndImage("POST", hubDetails, hubPhoto);
    return Hub.fromJson(response);
  }

  Future<Hub> updateHub(Hub hubDetails, XFile hubPhoto) async {
    final response =
        await _httpClient.sendDataAndImage("PUT", hubDetails, hubPhoto);
    return Hub.fromJson(response);
  }
}
