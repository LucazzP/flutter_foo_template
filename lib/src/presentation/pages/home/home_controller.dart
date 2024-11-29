import 'package:foo/src/presentation/base/controller/base.store.dart';
import 'package:foo/src/presentation/base/controller/value_state.store.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase extends BaseStore with Store {
  final counter = ValueState(0);

  @override
  Iterable<ValueState> get getStates => [counter];
}
