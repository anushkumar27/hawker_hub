import 'package:flutter/cupertino.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/services/api_response.dart';
import 'package:hawker_hub/services/hub_services.dart';
import 'package:image_picker/image_picker.dart';

/// Hub Provider
/// Main provider, holds data of all the retrived Hubs
class HubProvider extends ChangeNotifier {
  late HubServices _hubServices;

  // Hubs Data
  late ApiResponse<List<Hub>> _hubs;

  // Insert Hubs Response
  ApiResponse<dynamic>? _insertHubsResponse;

  // Selected Hub
  String? _selectedHubId;
  // Selected Hub Location Array Index
  int? _selectedHubLocationArrayIndex;

  String? get selectedHubId => _selectedHubId;
  int? get selectedHubLocationArrayIndex => _selectedHubLocationArrayIndex;

  ApiResponse<List<Hub>> get hubs => _hubs;
  ApiResponse<dynamic>? get insertHubsResponse => _insertHubsResponse;

  // Init the services and get all hubs
  HubProvider() {
    _hubServices = HubServices();
  }

  setSelectedHubIdAndLocationArrayIndex(
      String hubId, int hubLocationArrayIndex) {
    _selectedHubId = hubId;
    _selectedHubLocationArrayIndex = hubLocationArrayIndex;
    notifyListeners();
  }

  fetchAllHubs() async {
    _hubs = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      List<Hub> hubList = await _hubServices.fetchAllHubs();
      _hubs = ApiResponse.completed(hubList);
      notifyListeners();
    } catch (exception) {
      _hubs = ApiResponse.error(exception.toString());
      notifyListeners();
    }
  }

  insertHub(Hub hubDetails, XFile hubPhoto) async {
    _insertHubsResponse = ApiResponse.loading('Inserting Data');
    notifyListeners();
    try {
      dynamic response = await _hubServices.insertHub(hubDetails, hubPhoto);
      _insertHubsResponse = ApiResponse.completed(response);
      notifyListeners();
    } catch (exception) {
      _insertHubsResponse = ApiResponse.error(exception.toString());
      notifyListeners();
    }
  }
}
