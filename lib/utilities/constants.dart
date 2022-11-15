import 'package:flutter/material.dart';

class Constants {
  static const String appName = "Hawker Hub";
  static Color primarySurfaceColor = const Color(0x00fffbfe);
}

class DesignConstants {
  static hubDetailsCardShape(BuildContext context) => RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      );
}
