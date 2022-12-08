/// Hub Model
/// Stores a Hub's details
class Hub {
  String hubId;
  double hubRating;
  String hubPhoto;
  String hubName;
  String hubDescription;
  String hubCategory;
  int hubCostForTwo;
  List<HubLocation> hubLocations;

  Hub(
      {required this.hubId,
      required this.hubRating,
      required this.hubPhoto,
      required this.hubName,
      required this.hubDescription,
      required this.hubCategory,
      required this.hubCostForTwo,
      required this.hubLocations});

  factory Hub.fromJson(Map<String, dynamic> json) {
    dynamic hubLocations = <HubLocation>[];
    if (json['hub_locations'] != null) {
      json['hub_locations'].forEach((v) {
        hubLocations.add(HubLocation.fromJson(v));
      });
    }

    return Hub(
        hubId: json['hub_id'],
        hubRating: json['hub_rating'],
        hubPhoto: json['hub_photo'],
        hubName: json['hub_name'],
        hubDescription: json['hub_description'],
        hubCategory: json['hub_category'],
        hubCostForTwo: json['hub_cost_for_two'],
        hubLocations: hubLocations);
  }
}

class HubLocation {
  String hubAddress;
  double hubLatitude;
  double hubLogitude;
  int hubPhoneNumber;
  List<String> hubDaysOfOperation;
  String hubStartTime;
  String hubEndTime;

  HubLocation(
      {required this.hubAddress,
      required this.hubLatitude,
      required this.hubLogitude,
      required this.hubPhoneNumber,
      required this.hubDaysOfOperation,
      required this.hubStartTime,
      required this.hubEndTime});

  factory HubLocation.fromJson(Map<String, dynamic> json) {
    return HubLocation(
        hubAddress: json['hub_address'],
        hubLatitude: json['hub_latitude'],
        hubLogitude: json['hub_logitude'],
        hubPhoneNumber: json['hub_phone_number'],
        hubDaysOfOperation: json['hub_days_of_operation'].cast<String>(),
        hubStartTime: json['hub_start_time'],
        hubEndTime: json['hub_end_time']);
  }
}
