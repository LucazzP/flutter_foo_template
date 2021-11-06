import 'package:flutter/material.dart';
import 'package:foo/src/extensions/string.ext.dart';
import 'flavor_values.model.dart';

@immutable
class FlavorConfig {
  final Flavor _flavor;
  final String _name;
  final Color _color;
  final FlavorValues _values;
  static late final FlavorConfig _instance;

  factory FlavorConfig({
    required Flavor flavor,
    Color color = Colors.blue,
    required FlavorValues values,
  }) {
    _instance = FlavorConfig._internal(
      flavor,
      flavor.toString().getNameFromEnum(),
      color,
      values,
    );
    return _instance;
  }

  @visibleForTesting
  factory FlavorConfig.tests({
    required Flavor flavor,
    Color color = Colors.blue,
    required FlavorValues values,
  }) {
    _instance = FlavorConfig._internal(
        flavor, flavor.toString().getNameFromEnum(), color, values);
    return _instance;
  }

  const FlavorConfig._internal(this._flavor, this._name, this._color, this._values);

  static bool get isProduction => _instance._flavor == Flavor.production;
  static bool get isDevelopment => _instance._flavor == Flavor.dev;
  static bool get isQA => _instance._flavor == Flavor.qa;
  static Flavor get flavor => _instance._flavor;
  static String get name => _instance._name;
  static Color get color => _instance._color;
  static T values<T extends FlavorValues>() => _instance._values as T;
}

enum Flavor { dev, qa, production }
