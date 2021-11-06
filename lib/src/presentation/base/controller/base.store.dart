import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:foo/src/modules/logger/domain/log.usecase.dart';
import 'package:foo/src/presentation/base/controller/value_state.store.dart';
import 'package:mobx/mobx.dart';
import 'package:foo/src/core/failures.dart';

part 'base.store.g.dart';

/// Utilizado para ser a base de seus controllers/stores, nele você encontra
/// os métodos e atributos padrão para todos os controllers e stores.
abstract class BaseStore = _BaseStoreBase with _$BaseStore;

abstract class _BaseStoreBase extends Disposable with Store {
  /// Utilizado internamente dentro do [BaseStore] para acessar todos os estados
  /// disponíveis na classe implementadora.
  ///
  /// IMPORTANTE: Sempre que for adicionar um estado dentro de um controller,
  /// deve-se adicionar o mesmo na lista do [getStates] também através de seu
  /// @override.
  @protected
  Iterable<ValueState> get getStates;

  /// Mesma finalidade do [getStates], a diferença é que esse é um `computed` que
  /// notificará para o os outros `computed` que estão escutando ele.
  ///
  /// É necessário esses dois atributos e não apenas um porque o mobx me obriga
  /// a implementar todos os atributos `computed`, sendo assim, não consigo
  /// deixar o [getStates] como `computed` porque ele deve ser implementado
  /// pela classe implementadora, e não pelo [BaseStore].
  @computed
  @visibleForTesting
  Iterable<ValueState> get states => getStates;

  /// Resgata a primeira [Failure] encontrada dentro de todos os estados.
  @computed
  Failure? get failure {
    try {
      return states.firstWhere((element) => element.hasFailure).failure;
    } on StateError catch (e) {
      if (e.toString() == 'Bad state: No element') {
        return null;
      } else {
        rethrow;
      }
    }
  }

  /// Retorna `true` se pelo menos um dos estados estiver em loading.
  @computed
  bool get isLoading => states.any((element) => element.isLoading);

  /// Retorna `true` se pelo menos um dos estados possuir alguma [Failure].
  @computed
  bool get hasFailure => states.any((element) => element.hasFailure);

  /// Executa o método `execute` do estado encontrado dentro do [getStates].
  /// Se não encontrar nenhum estado, é realizado um log e não ocorre mais nada.
  ///
  /// IMPORTANTE: Se existirem dois estados com o mesmo tipo, **o primeiro**
  /// encontrado será o que será executado.
  ///
  /// Copy from ValueStore.execute:
  /// Executa uma função que retorna um [Future] com o valor que será guardado.
  /// Enquanto executa a função, ele automaticamente coloca em estado de
  /// `isLoading` e caso ocorra algum erro, ele seta o error no `failure` e fica
  /// em estado de `hasFailure`.
  /// Assim como, coloca automaticamente o estado de `isLoading` para `false`.
  @protected
  @nonVirtual
  @visibleForTesting
  Future<void> execute<T>(Future<Either<Failure, T>> Function() exec) async {
    try {
      ValueState<T> state =
          states.firstWhere((element) => element is ValueState<T>) as ValueState<T>;
      return state.execute(exec);
    } catch (e) {
      String error;
      if (e.toString() == 'Bad state: No element') {
        error = 'Não foi possível encontrar o estado $T registrado '
            'na lista do `getStates` do `BaseStore`, verifique se está registrado '
            'corretamente';
      } else {
        error = e.toString();
      }
      await Modular.get<LogUseCase>().call(error);
    }
  }

  /// Busca todos os estados que possuem alguma [Failure] e seta a mesma para
  /// none().
  @nonVirtual
  void clearErrors() {
    states.where((state) => state.hasFailure).forEach((state) => state.setFailure(null));
  }

  @override
  @mustCallSuper
  void dispose() {}
}
