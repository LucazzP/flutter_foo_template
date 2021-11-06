import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foo/src/core/failures.dart';
import 'package:foo/src/presentation/base/controller/base.store.dart';
import 'package:foo/src/presentation/base/controller/value_state.store.dart';
import 'package:mobx/mobx.dart';

import '../mocks/navigation.mocks.dart';

const kComputed = 'computed';
const kAction = 'action';

void expectLastNavigation(List<RouteEvent> navigationList, String newRoute,
    {Object? args, String? previousRoute, Object? previousRouteArgs, bool isPop = false}) {
  final last = navigationList.last;
  RouteEvent routeEvent;

  if (isPop) {
    routeEvent = RouteEvent(RouteSettings(name: newRoute, arguments: null), null);
  } else if (previousRoute == null) {
    routeEvent = RouteEvent.newRoute(
      RouteSettings(name: newRoute, arguments: args),
    );
  } else {
    routeEvent = RouteEvent(
      RouteSettings(name: newRoute, arguments: args),
      RouteSettings(name: previousRoute, arguments: previousRouteArgs),
    );
  }
  expect(last, equals(routeEvent));
}

void expectMobx<T, P1, P2, P3>(
  Iterable<SpyEvent> spyEvents, {
  required T Function() getObject,
  required bool Function(SpyEvent event) checkEvent,
  P1? param1,
  P2? param2,
  P3? param3,
}) {
  T object;
  var objIsFunc = false;

  final dispose = autorun((_) {
    object = getObject();

    if (objIsFunc || object is Function) {
      objIsFunc = true;

      if (param1 != null && param2 != null && param3 != null) {
        (object as Function(P1, P2, P3))(param1, param2, param3);
      } else if (param1 != null && param2 != null) {
        (object as Function(P1, P2))(param1, param2);
      } else if (param1 != null) {
        (object as Function(P1))(param1);
      } else {
        (object as Function())();
      }
    }
  });

  object = getObject();

  expect(
    spyEvents
        .any((event) => checkEvent(event) && (objIsFunc ? true : event.object?.value == object)),
    isTrue,
  );

  dispose();
}

Future<void> expectExecute<T>(
  Future<void> Function() func,
  ValueState<T> valueState,
  BaseStore baseStore, {
  T? result,
  Failure? failure,
  bool? verifyResult,
  bool? verifyFailure,
}) async {
  verifyResult ??= result != null;
  verifyFailure ??= failure != null;
  expect(baseStore.isLoading, isFalse);
  expect(baseStore.hasFailure, isFalse);

  final future = func();
  expect(baseStore.isLoading, isTrue);
  expect(baseStore.hasFailure, isFalse);

  await future;

  expect(valueState.isLoading, isFalse);
  expect(baseStore.isLoading, isFalse);
  if (verifyResult) {
    expect(valueState.value, equals(result));
  }
  if (verifyFailure) {
    expect(baseStore.hasFailure, isTrue);
    expect(baseStore.failure, equals(failure));
  } else {
    expect(baseStore.hasFailure, isFalse);
  }
}
