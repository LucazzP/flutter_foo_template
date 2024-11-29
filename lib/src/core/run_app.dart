import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:foo/src/core/firebase_options.dart';
import 'flavor/build_config.model.dart';
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
    BuildConfig(
      flavor: flavor,
      color: flavor == Flavor.dev ? Colors.green : Colors.deepPurpleAccent,
      values: flavorValues,
    );

    runZonedGuarded(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      Isolate.current.addErrorListener(RawReceivePort((pair) {
        final List<dynamic> errorAndStacktrace = pair;
        FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
        );
      }).sendPort);
      runApp(rootWidget);
    }, (exception, stack) {
      FirebaseCrashlytics.instance.recordError(exception, stack, fatal: true);
    });
  }
}
