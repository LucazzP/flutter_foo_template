import 'package:flutter/material.dart';
import 'package:foo/src/core/extensions/string.ext.dart';
import 'flavor_values.model.dart';

@immutable
class BuildConfig {
  final Flavor _flavor;
  final String _name;
  final Color _color;
  final FlavorValues _values;
  static late final BuildConfig _instance;

  factory BuildConfig({
    required Flavor flavor,
    Color color = Colors.blue,
    required FlavorValues values,
  }) {
    _instance = BuildConfig._internal(
      flavor,
      flavor.toString().getNameFromEnum(),
      color,
      values,
    );
    return _instance;
  }

  @visibleForTesting
  factory BuildConfig.tests({
    required Flavor flavor,
    Color color = Colors.blue,
    required FlavorValues values,
  }) {
    _instance = BuildConfig._internal(flavor, flavor.toString().getNameFromEnum(), color, values);
    return _instance;
  }

  const BuildConfig._internal(this._flavor, this._name, this._color, this._values);

  static bool get isProduction => _instance._flavor == Flavor.production;
  static bool get isDevelopment => _instance._flavor == Flavor.dev;
  static bool get isQA => _instance._flavor == Flavor.qa;
  static Flavor get flavor => _instance._flavor;
  static String get name => _instance._name;
  static Color get color => _instance._color;
  static T values<T extends FlavorValues>() => _instance._values as T;
}

enum Flavor { dev, qa, production }
