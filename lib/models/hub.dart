import "package:equatable/equatable.dart";

/// Hub Model
/// Stores a Hub's details
class Hub extends Equatable {
  final String hubId;
  final double hubRating;
  final String hubPhoto;
  final String hubName;
  final String hubDescription;
  final String hubCategory;
  final String hubCostForTwo;
  final List<HubLocation> hubLocations;

  const Hub(
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
        hubRating: json['hub_rating'].toDouble(),
        hubPhoto: json['hub_photo'],
        hubName: json['hub_name'],
        hubDescription: json['hub_description'],
        hubCategory: json['hub_category'],
        hubCostForTwo: json['hub_cost_for_two'],
        hubLocations: hubLocations);
  }

  Map<String, dynamic> toJson() => {
        "hub_id": hubId,
        "hub_rating": hubRating,
        "hub_photo": hubPhoto,
        "hub_name": hubName,
        "hub_description": hubDescription,
        "hub_category": hubCategory,
        "hub_cost_for_two": hubCostForTwo,
        "hub_locations": hubLocations
            .map((hubLocation) => hubLocation.toJson())
            .toList(growable: false)
      };

  @override
  List<Object?> get props => [
        hubId,
        hubRating,
        hubPhoto,
        hubName,
        hubDescription,
        hubCategory,
        hubCostForTwo,
        hubLocations
      ];
}

class HubLocation extends Equatable {
  final String hubAddress;
  final double hubLatitude;
  final double hubLongitude;
  final String hubPhoneNumber;
  final List<String> hubDaysOfOperation;
  final String hubStartTime;
  final String hubEndTime;

  const HubLocation(
      {required this.hubAddress,
      required this.hubLatitude,
      required this.hubLongitude,
      required this.hubPhoneNumber,
      required this.hubDaysOfOperation,
      required this.hubStartTime,
      required this.hubEndTime});

  factory HubLocation.fromJson(Map<String, dynamic> json) {
    return HubLocation(
        hubAddress: json['hub_address'],
        hubLatitude: json['hub_latitude'],
        hubLongitude: json['hub_longitude'],
        hubPhoneNumber: json['hub_phone_number'],
        hubDaysOfOperation: json['hub_days_of_operation'].cast<String>(),
        hubStartTime: json['hub_start_time'],
        hubEndTime: json['hub_end_time']);
  }

  Map<String, dynamic> toJson() {
    return {
      "hub_days_of_operation": hubDaysOfOperation,
      "hub_start_time": hubStartTime,
      "hub_phone_number": hubPhoneNumber,
      "hub_longitude": hubLongitude,
      "hub_latitude": hubLatitude,
      "hub_address": hubAddress,
      "hub_end_time": hubEndTime
    };
  }

  @override
  List<Object?> get props => [
        hubAddress,
        hubLatitude,
        hubLongitude,
        hubPhoneNumber,
        hubDaysOfOperation,
        hubStartTime,
        hubEndTime
      ];
}
