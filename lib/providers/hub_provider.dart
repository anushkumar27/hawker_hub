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
  ApiResponse<Hub>? _insertHubsResponse;

  // Update Hubs Response
  ApiResponse<Hub>? _updateHubsResponse;

  // Selected Hub
  String? _selectedHubId;
  // Selected Hub Location Array Index
  int? _selectedHubLocationArrayIndex;

  String? get selectedHubId => _selectedHubId;
  int? get selectedHubLocationArrayIndex => _selectedHubLocationArrayIndex;

  ApiResponse<List<Hub>> get hubs => _hubs;
  ApiResponse<Hub>? get insertHubsResponse => _insertHubsResponse;
  ApiResponse<Hub>? get updateHubsResponse => _updateHubsResponse;

  HubProvider(HubServices hubServices) {
    _hubServices = hubServices;
    // Init _hubs
    _hubs = ApiResponse.loading('Fetching Data');
  }

  resetResponses() {
    _insertHubsResponse = null;
    _updateHubsResponse = null;
    notifyListeners();
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
      Hub hub = await _hubServices.insertHub(hubDetails, hubPhoto);
      _insertHubsResponse = ApiResponse.completed(hub);

      // Remove if it already exist
      _hubs.data.removeWhere((listHub) => listHub.hubId == hub.hubId);
      // Update the overall hub list
      _hubs.data.add(hub);
      notifyListeners();
    } catch (exception) {
      _insertHubsResponse = ApiResponse.error(exception.toString());
      notifyListeners();
    }
  }

  updateHub(Hub hubDetails, XFile hubPhoto) async {
    _updateHubsResponse = ApiResponse.loading('Updating Data');
    notifyListeners();
    try {
      Hub hub = await _hubServices.updateHub(hubDetails, hubPhoto);
      _updateHubsResponse = ApiResponse.completed(hub);

      // Remove if it already exist
      _hubs.data.removeWhere((listHub) => listHub.hubId == hub.hubId);
      // Update the overall hub list
      _hubs.data.add(hub);
      notifyListeners();
    } catch (exception) {
      _updateHubsResponse = ApiResponse.error(exception.toString());
      notifyListeners();
    }
  }
}
