import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foo/src/presentation/navigation_args/args.dart';
import 'package:mocktail/mocktail.dart';

class NavigatorObserverMock extends Mock implements NavigatorObserver {
  final pushes = <RouteEvent>[];
  final pops = <RouteEvent>[];
  final removes = <RouteEvent>[];
  final replaces = <RouteEvent>[];

  void reset() {
    pushes.clear();
    pops.clear();
    removes.clear();
    replaces.clear();
  }

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    pushes.add(RouteEvent(route?.settings, previousRoute?.settings));
  }

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    pops.add(RouteEvent(route?.settings, previousRoute?.settings));
  }

  @override
  void didRemove(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    removes.add(RouteEvent(route?.settings, previousRoute?.settings));
  }

  @override
  void didReplace({Route<dynamic>? oldRoute, Route<dynamic>? newRoute}) {
    replaces.add(RouteEvent(newRoute?.settings, oldRoute?.settings));
  }
}

class RouteEvent {
  final RouteSettings? newRoute;
  final RouteSettings? previousRoute;

  const RouteEvent(this.newRoute, this.previousRoute);
  const RouteEvent.newRoute(this.newRoute) : previousRoute = const RouteSettings(name: '/');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RouteEvent &&
        other.newRoute?.arguments == newRoute?.arguments &&
        other.newRoute?.name == newRoute?.name &&
        other.previousRoute?.arguments == previousRoute?.arguments &&
        other.previousRoute?.name == previousRoute?.name;
  }

  @override
  int get hashCode =>
      (newRoute?.arguments.hashCode ?? 0) ^
      (newRoute?.name.hashCode ?? 0) ^
      (previousRoute?.arguments.hashCode ?? 0) ^
      (previousRoute?.name.hashCode ?? 0);

  @override
  String toString() => 'RouteEvent(newRoute: $newRoute, previousRoute: $previousRoute)';
}

// ignore:must_be_immutable
class NavigatorMock extends Navigator {
  final NavigatorStateMock? state;

  const NavigatorMock(
    this.state, {
    Key? key,
    List<Page<dynamic>> pages = const <Page<dynamic>>[],
    PopPageCallback? onPopPage,
    String? initialRoute,
    RouteListFactory onGenerateInitialRoutes = Navigator.defaultGenerateInitialRoutes,
    RouteFactory? onGenerateRoute,
    RouteFactory? onUnknownRoute,
    TransitionDelegate<dynamic> transitionDelegate = const DefaultTransitionDelegate<dynamic>(),
    List<NavigatorObserver> observers = const <NavigatorObserver>[],
  }) : super(
          key: key,
          pages: pages,
          onPopPage: onPopPage,
          initialRoute: initialRoute,
          onGenerateInitialRoutes: onGenerateInitialRoutes,
          onGenerateRoute: onGenerateRoute,
          onUnknownRoute: onUnknownRoute,
          transitionDelegate: transitionDelegate,
          observers: observers,
        );

  @override
  NavigatorState createState() {
    // ignore: no_logic_in_create_state
    return state?.copy() ?? NavigatorState();
  }
}

class NavigatorStateMock extends NavigatorState {
  final List<NavigatorEvent> pushesNamedAndRemoveUntil;
  final List<NavigatorEvent> pushesReplacementNamed;
  final List<NavigatorEvent> pushesNamed;
  final List<NavigatorEvent> pops;
  final List<NavigatorEvent> popsUntil;

  NavigatorStateMock({
    List<NavigatorEvent>? pushesNamedAndRemoveUntil,
    List<NavigatorEvent>? pushesReplacementNamed,
    List<NavigatorEvent>? pushesNamed,
    List<NavigatorEvent>? pops,
    List<NavigatorEvent>? popsUntil,
  })  : pushesNamedAndRemoveUntil = pushesNamedAndRemoveUntil ?? <NavigatorEvent>[],
        pushesReplacementNamed = pushesReplacementNamed ?? <NavigatorEvent>[],
        pushesNamed = pushesNamed ?? <NavigatorEvent>[],
        pops = pops ?? <NavigatorEvent>[],
        popsUntil = popsUntil ?? <NavigatorEvent>[];

  NavigatorStateMock copy() => NavigatorStateMock(
        pushesNamedAndRemoveUntil: pushesNamedAndRemoveUntil,
        pushesReplacementNamed: pushesReplacementNamed,
        pushesNamed: pushesNamed,
        pops: pops,
        popsUntil: popsUntil,
      );

  void reset() {
    pushesNamedAndRemoveUntil.clear();
    pushesReplacementNamed.clear();
    pushesNamed.clear();
    pops.clear();
    popsUntil.clear();
  }

  bool haveSomeNavigation() {
    return pushesNamedAndRemoveUntil.isNotEmpty &&
        pushesReplacementNamed.isNotEmpty &&
        pushesNamed.isNotEmpty &&
        pops.isNotEmpty &&
        popsUntil.isNotEmpty;
  }

  @override
  void pop<T extends Object?>([T? result]) {
    pops.add(NavigatorEvent.pop(result));
  }

  @override
  void popUntil(RoutePredicate predicate) {
    popsUntil.add(NavigatorEvent._(predicate: predicate));
  }

  @override
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) async {
    pushesNamed.add(NavigatorEvent.pushNamed(routeName, arguments: arguments as NavigationArg<dynamic>?));
    return null;
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(String routeName,
      {TO? result, Object? arguments}) async {
    pushesReplacementNamed.add(NavigatorEvent.pushReplacementNamed(
      routeName,
      arguments: arguments as NavigationArg<dynamic>?,
      result: result,
    ));
    return null;
  }

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) async {
    pushesNamedAndRemoveUntil.add(NavigatorEvent.pushNamedAndRemoveUntil(
      newRouteName,
      predicate: predicate,
      arguments: arguments as NavigationArg<dynamic>?,
    ));
    return null;
  }
}

class NavigatorEvent extends Equatable {
  final dynamic result;
  final String? route;
  final NavigationArg<dynamic>? arguments;
  final RoutePredicate? predicate;

  const NavigatorEvent._({
    this.result,
    this.route,
    this.arguments,
    this.predicate,
  });

  const NavigatorEvent.pop(this.result)
      : route = null,
        arguments = null,
        predicate = null;

  NavigatorEvent.popUntil(String routeToReach)
      : result = null,
        route = null,
        arguments = null,
        predicate = ModalRoute.withName(routeToReach);

  const NavigatorEvent.pushNamed(this.route, {this.arguments})
      : result = null,
        predicate = null;

  const NavigatorEvent.pushReplacementNamed(this.route, {this.arguments, this.result})
      : predicate = null;

  const NavigatorEvent.pushNamedAndRemoveUntil(this.route, {this.predicate, this.arguments})
      : result = null;

  @override
  List<Object?> get props => [result, route, arguments, predicate];

  @override
  bool get stringify => true;
}
