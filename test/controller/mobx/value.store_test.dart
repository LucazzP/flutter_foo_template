import 'package:flutter_test/flutter_test.dart';
import 'package:foo/src/presentation/base/controller/value.store.dart';
import 'package:mobx/mobx.dart';

import '../../utils/expects.dart';

Future<void> main() async {
  final spyEvents = <SpyEvent>[];
  late ValueStore<bool> value;

  setUp(() {
    mainContext.config = mainContext.config.clone(isSpyEnabled: true);
    mainContext.spy(spyEvents.add);
    value = ValueStore(false);
  });

  tearDown(() {
    spyEvents.clear();
  });

  group('Check ValueStore', () {
    test('should set the initialValue on _value', () {
      final value = ValueStore(true);
      expect(value.value, isTrue);
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
      });
    });

    test('equality should be true if all attributes is equals', () {
      final value1 = ValueStore(true);
      final value2 = ValueStore(true);

      expect(value1 == value2, isTrue);
      expect(value1.hashCode == value2.hashCode, isTrue);
    });
  });
}
