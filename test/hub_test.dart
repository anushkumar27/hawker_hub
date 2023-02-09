import 'package:flutter_test/flutter_test.dart';
import 'package:hawker_hub/models/hub.dart';

void main() {
  Map<String, dynamic> hubOneAsJson = {
    "hub_cost_for_two": "123",
    "hub_category": "Other",
    "hub_rating": 5,
    "hub_name": "test hub",
    "hub_locations": [
      {
        "hub_days_of_operation": ["Monday", "Wednesday", "Friday"],
        "hub_start_time": "08:00",
        "hub_phone_number": "+1123456789",
        "hub_end_time": "20:00",
        "hub_latitude": 44.57418808742632,
        "hub_address": "123 NW 23rd St, Corvallis, Oregon 97330, United States",
        "hub_longitude": -123.27743701636791
      },
      {
        "hub_days_of_operation": ["Tuesday", "Saturday", "Thursday"],
        "hub_start_time": "08:00",
        "hub_phone_number": "+1987654321",
        "hub_end_time": "20:00",
        "hub_latitude": 44.57656130628247,
        "hub_address":
            "1115 NW 19th St, Corvallis, Oregon 97330, United States",
        "hub_longitude": -123.27305629849434
      }
    ],
    "hub_id": "c5cc19b3-4467-4219-86e4-086ae7e128f8",
    "hub_photo":
        "https://hubs-image.s3.amazonaws.com/c5cc19b3-4467-4219-86e4-086ae7e128f8.jpg",
    "hub_description": "test description"
  };
  Hub expectedHubOneModel = const Hub(
      hubId: "c5cc19b3-4467-4219-86e4-086ae7e128f8",
      hubRating: 5,
      hubPhoto:
          "https://hubs-image.s3.amazonaws.com/c5cc19b3-4467-4219-86e4-086ae7e128f8.jpg",
      hubName: "test hub",
      hubDescription: "test description",
      hubCategory: "Other",
      hubCostForTwo: "123",
      hubLocations: [
        HubLocation(
            hubAddress:
                "123 NW 23rd St, Corvallis, Oregon 97330, United States",
            hubLatitude: 44.57418808742632,
            hubLongitude: -123.27743701636791,
            hubPhoneNumber: "+1123456789",
            hubDaysOfOperation: ["Monday", "Wednesday", "Friday"],
            hubStartTime: "08:00",
            hubEndTime: "20:00"),
        HubLocation(
            hubAddress:
                "1115 NW 19th St, Corvallis, Oregon 97330, United States",
            hubLatitude: 44.57656130628247,
            hubLongitude: -123.27305629849434,
            hubPhoneNumber: "+1987654321",
            hubDaysOfOperation: ["Tuesday", "Saturday", "Thursday"],
            hubStartTime: "08:00",
            hubEndTime: "20:00")
      ]);

  // Previous declarations
  group("Test Hub model initialization from json", () {
    test("Test using hubOneAsJson", () {
      expect(Hub.fromJson(hubOneAsJson), expectedHubOneModel);
    });
  });

  group("Test Hub model to json", () {
    test("Test using using expectedHubOneModel", () {
      expect(expectedHubOneModel.toJson(), hubOneAsJson);
    });
  });
}
