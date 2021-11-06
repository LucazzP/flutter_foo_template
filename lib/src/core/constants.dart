import 'dart:io';

import 'flavor/flavor_config.model.dart';
import 'flavor/flavor_values.model.dart';

import 'features.dart';

final kTestMode = Platform.environment.containsKey('FLUTTER_TEST');

FlavorValues get flavor => FlavorConfig.values();

final kFlavorDev = FlavorValues(
  baseUrl: kLocalhost,
  features: () => Features.dev,
);

final kFlavorQa = FlavorValues(
  baseUrl: kLocalhost,
  features: () => Features.qa,
);

final kFlavorProd = FlavorValues(
  baseUrl: kLocalhost,
  features: () => Features.prod,
);

const kLocalhost = 'http://localhost';
const kLocalhostAndroid = 'http://10.0.2.2';
