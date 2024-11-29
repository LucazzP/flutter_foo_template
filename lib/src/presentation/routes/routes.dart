import 'package:collection/collection.dart';

enum Routes {
  initialRoute('/');

  const Routes(this._route);

  final String _route;

  String route([Map<String, dynamic> params = const {}]) {
    final cleanedParams = params.map((key, value) {
      if (value is List) {
        return MapEntry(key, value.join(','));
      }
      if (value is Map) {
        return MapEntry(key, value.entries.map((e) => '${e.key}:${e.value}').join(','));
      }
      return MapEntry(key, value);
    })
      ..removeWhere((key, value) => value == null || value == '');
    if (cleanedParams.isEmpty) return _route;
    return Uri(path: _route, queryParameters: cleanedParams).toString();
  }

  static Routes? fromString(String? route) {
    if (route == null) return null;
    final routeWithoutQuery = route.split('?').first;
    final exactRoute =
        Routes.values.firstWhereOrNull((element) => routeWithoutQuery == element._route);
    return exactRoute;
  }
}
