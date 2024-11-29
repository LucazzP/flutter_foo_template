import 'package:flutter/material.dart';
import 'package:foo/src/presentation/app_widget.dart';
import 'package:foo/src/core/constants.dart';
import 'package:foo/src/core/flavor/flavor_config.model.dart';
import 'package:foo/src/core/run_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  RunApp(
    const AppWidget(),
    flavorValues: kFlavorDev,
    flavor: Flavor.dev,
  );
}
