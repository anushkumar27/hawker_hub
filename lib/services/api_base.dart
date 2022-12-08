import 'package:flutter/foundation.dart';

/// APIBase
/// Holds the base URL for the backend server
// TODO: Update PROD URL
class APIBase {
  static String get baseURL {
    if (kReleaseMode) {
      return "PROD_URL";
    } else {
      // Localhost URL (dev)
      return "http://10.0.2.2:1080/hub";
    }
  }
}
