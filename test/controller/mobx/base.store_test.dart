import 'package:flutter_test/flutter_test.dart';
import 'package:foo/src/modules/logger/domain/log.usecase.dart';
import 'package:foo/src/presentation/base/disposable.dart';
import 'package:get_it/get_it.dart' hide Disposable;
import 'package:mobx/mobx.dart' hide when;
import 'package:foo/src/core/failures.dart';
import 'package:mocktail/mocktail.dart';
import '../../mocks/controller.mocks.dart';
import '../../utils/expects.dart';

class LogUseCaseMock extends Mock implements LogUseCase {}

Future<void> main() async {
  final spyEvents = <SpyEvent>[];
  final logUseCaseMock = LogUseCaseMock();
  late ControllerTest store;

  setUpAll(() {
    GetIt.I.registerSingleton<LogUseCase>(logUseCaseMock);
  });

  setUp(() {
    mainContext.config = mainContext.config.clone(isSpyEnabled: true);
    mainContext.spy(spyEvents.add);
    store = ControllerTest();
    when(() => logUseCaseMock.call(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    store.dispose();
    reset(logUseCaseMock);
    spyEvents.clear();
  });

  group('Check BaseStore', () {
    group('states atribute', () {
      test('should be equals getStates result', () {
        expect(store.states, equals(store.getStates));
      });

      test('should be a Computed', () async {
        expectMobx(
          spyEvents,
          getObject: () => store.states,
          checkEvent: (event) => event.type == kComputed,
        );
      });
    });

    group('failure atribute', () {
      test('should be the first failure on states', () {
        store.otherState.setFailure(kServerFailure);
        expect(store.failure, equals(store.otherState.failure));

        store.state.setFailure(kServerFailure);

        expect(store.failure, equals(store.state.failure));
      });

      test('should be null when dont have failures on states', () {
        store.otherState.setFailure(null);
        expect(store.failure, equals(null));
      });

      test('should be a Computed', () async {
        expectMobx(
          spyEvents,
          getObject: () => store.failure,
          checkEvent: (event) => event.type == kComputed,
        );
      });
    });

    group('isLoading atribute', () {
      test('should be true if any of states isLoading', () {
        store.otherState.setLoading(true);
        expect(store.isLoading, isTrue);

        store.otherState.setLoading(false);
        expect(store.isLoading, isFalse);

        store.state.setLoading(true);
        expect(store.isLoading, isTrue);
      });

      test('should be a Computed', () async {
        expectMobx(
          spyEvents,
          getObject: () => store.isLoading,
          checkEvent: (event) => event.type == kComputed,
        );
      });
    });

    group('hasFailure atribute', () {
      test('should be true if any of states hasFailure', () {
        store.otherState.setFailure(kServerFailure);
        expect(store.hasFailure, isTrue);

        store.otherState.setFailure(null);
        expect(store.hasFailure, isFalse);

        store.state.setFailure(kServerFailure);
        expect(store.hasFailure, isTrue);
      });

      test('should be a Computed', () async {
        expectMobx(
          spyEvents,
          getObject: () => store.hasFailure,
          checkEvent: (event) => event.type == kComputed,
        );
      });
    });

    test('clearErrors function should set all failures to null', () {
      expect(store.hasFailure, isFalse);

      store.otherState.setFailure(kServerFailure);
      store.state.setFailure(kServerFailure);
      expect(store.hasFailure, isTrue);

      store.clearErrors();
      expect(store.hasFailure, isFalse);
    });

    test('should be an Disposable with a dispose pre-implemented', () {
      expect(store, isA<Disposable>());

      expect(store.disposed, isFalse);
      store.dispose();
      expect(store.disposed, isTrue);
    });
  });
}
