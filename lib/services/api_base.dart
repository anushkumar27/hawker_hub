import 'package:flutter/foundation.dart';

/// APIBase
/// Holds the base URL for the backend server
class APIBase {
  static String get baseURL {
    if (kReleaseMode) {
      return "https://o7bd36fp29.execute-api.us-west-2.amazonaws.com/Prod/hub/";
    } else {
      // return "http://10.0.2.2:1080/hub"; // Localhost URL (dev)
      return "https://o7bd36fp29.execute-api.us-west-2.amazonaws.com/Stage/hub"; // Stage URL (stage)
    }
  }
}
