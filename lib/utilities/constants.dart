import 'package:flutter/material.dart';

class Constants {
  static const String appName = "Hawker Hub";
  static Color primarySurfaceColor = const Color(0x00fffbfe);
  static const clientNetworkTimeout = Duration(seconds: 5);
}

class DesignConstants {
  static hubDetailsCardShape(BuildContext context) => RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      );
}
