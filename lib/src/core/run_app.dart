import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'flavor/flavor_config.model.dart';
import 'flavor/flavor_values.model.dart';

class RunApp {
  final Widget rootWidget;
  final FlavorValues flavorValues;
  final Flavor flavor;
  final Future<void> Function(FlutterErrorDetails errorDetails)? errorReporter;

  RunApp(
    this.rootWidget, {
    this.errorReporter,
    required this.flavorValues,
    this.flavor = Flavor.production,
  }) {
    FlavorConfig(
      flavor: flavor,
      color: flavor == Flavor.dev ? Colors.green : Colors.deepPurpleAccent,
      values: flavorValues,
    );

    runApp(rootWidget);
  }
}
