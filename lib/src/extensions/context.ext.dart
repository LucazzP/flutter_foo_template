import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foo/src/core/constants.dart';
import 'package:foo/src/presentation/navigation_args/navigation_arg.model.dart';

extension ContextExtension on BuildContext {
  bool get isSmallDevice => MediaQuery.of(this).size.height < 670;

  void pop<T>([T? result]) {
    if (Navigator.of(this).canPop() || kTestMode) {
      Navigator.of(this).pop<T>(result);
    }
  }

  void popUntil(String routeToReach) {
    Navigator.of(this).popUntil(ModalRoute.withName(routeToReach));
  }

  Future<Result> pushNamed<T, Result>(String route, [NavigationArg<T>? arg]) =>
      Navigator.of(this).pushNamed(route, arguments: arg).then((value) => value as Result);

  Future<Result> replaceRouteWith<T, Result>(String route, [NavigationArg<T>? arg]) =>
      Navigator.of(this)
          .pushReplacementNamed(
            route,
            arguments: arg,
          )
          .then((value) => value as Result);

  Future<Result> pushNamedAndRemoveUntil<Result, T>(String namedRoute, RoutePredicate predicate,
          [NavigationArg<T>? arg]) =>
      Navigator.of(this)
          .pushNamedAndRemoveUntil(
            namedRoute,
            predicate,
            arguments: arg,
          )
          .then((value) => value as Result);
}
