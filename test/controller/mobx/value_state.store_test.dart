import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foo/src/presentation/base/controller/value_state.store.dart';
import 'package:mobx/mobx.dart';
import 'package:foo/src/core/failures.dart';

import '../../utils/expects.dart';

Future<void> main() async {
  final spyEvents = <SpyEvent>[];
  late ValueState<bool> value;

  setUp(() {
    mainContext.config = mainContext.config.clone(isSpyEnabled: true);
    mainContext.spy(spyEvents.add);
    value = ValueState(false);
  });

  tearDown(() {
    spyEvents.clear();
  });

  group('Check ValueStore', () {
    test('should set the initialValue on _value', () {
      final value = ValueState(true);
      expect(value.value, isTrue);
    });

    group('should initialize with', () {
      test('failure as null', () {
        expect(value.failure, equals(null));
      });
      test('isLoading as false', () {
        expect(value.isLoading, isFalse);
      });
    });

    group('should be', () {
      group('a computed', () {
        test('value attribute', () {
          expectMobx(
            spyEvents,
            getObject: () => value.value,
            checkEvent: (event) => event.type == kComputed,
          );
        });

        test('failure attribute', () {
          expectMobx(
            spyEvents,
            getObject: () => value.failure,
            checkEvent: (event) => event.type == kComputed,
          );
        });

        test('isLoading attribute', () {
          expectMobx(
            spyEvents,
            getObject: () => value.isLoading,
            checkEvent: (event) => event.type == kComputed,
          );
        });

        test('hasFailure attribute', () {
          expectMobx(
            spyEvents,
            getObject: () => value.hasFailure,
            checkEvent: (event) => event.type == kComputed,
          );
        });
      });
      group('an action', () {
        test('setValue function', () {
          expectMobx(
            spyEvents,
            getObject: () => value.setValue,
            param1: true,
            checkEvent: (event) => event.type == kAction,
          );
        });

        test('setFailure function', () {
          expectMobx(
            spyEvents,
            getObject: () => value.setFailure,
            param1: kServerFailure,
            checkEvent: (event) => event.type == kAction,
          );
        });

        test('setLoading function', () {
          expectMobx(
            spyEvents,
            getObject: () => value.setLoading,
            param1: true,
            checkEvent: (event) => event.type == kAction,
          );
        });
      });
    });

    test('hasFailure attribute should verify if failure isSome', () {
      expect(value.hasFailure, isFalse);

      value.setFailure(kServerFailure);
      expect(value.hasFailure, isTrue);

      value.setFailure(null);
      expect(value.hasFailure, isFalse);
    });

    group('execute function should', () {
      test('setLoading as true when initialize', () {
        value.execute(() async => const Right(true));
        expect(value.isLoading, isTrue);
      });

      group('setLoading as false when finish', () {
        test('without error', () async {
          await value.execute(() async => const Right(true));
          expect(value.isLoading, isFalse);
        });
        test('when occours an exception', () async {
          await value.execute(() async => throw Exception());
          expect(value.isLoading, isFalse);
        });
      });

      test('setValue with Right value when exec() returns Right', () async {
        await value.execute(() async => const Right(true));
        expect(value.value, isTrue);

        await value.execute(() async => const Right(false));
        expect(value.value, isFalse);
      });

      group('setFailure when', () {
        test('exec() returns a Left(Failure)', () async {
          await value.execute(() async => const Left(kServerFailure));
          expect(value.failure, kServerFailure);
        });
        test('occours an exception', () async {
          await value.execute(() async => throw Exception());
          expect(value.failure, kAppFailure);
        });
      });
    });

    test('equality should be true if all attributes is equals', () {
      final value1 = ValueState(true);
      final value2 = ValueState(true);

      expect(value1 == value2, isTrue);
      expect(value1.hashCode == value2.hashCode, isTrue);
    });
  });
}
