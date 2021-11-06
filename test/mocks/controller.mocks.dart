import 'package:mobx/mobx.dart';
import 'package:foo/src/presentation/base/controller/base.store.dart';
import 'package:foo/src/presentation/base/controller/value_state.store.dart';
import 'package:mocktail/mocktail.dart';

part 'controller.mocks.g.dart';

class ControllerTest = _ControllerTestBase with _$ControllerTest;

abstract class _ControllerTestBase extends BaseStore with Store {
  final bool useMock;

  _ControllerTestBase([bool? useMock]) : useMock = useMock ?? false;

  var disposed = false;
  final state = ValueState(false);
  final otherState = ValueState(false);
  final otherState2 = ValueState('');
  final mockedState = ValueStoreMock<double>();

  @override
  Iterable<ValueState> get getStates {
    final list = [state, otherState, otherState2];
    if (useMock) {
      list.add(mockedState);
    }
    return list;
  }

  @override
  void dispose() {
    disposed = true;
    reset(mockedState);
    super.dispose();
  }
}

class ValueStoreMock<T> extends Mock implements ValueState<T> {}
