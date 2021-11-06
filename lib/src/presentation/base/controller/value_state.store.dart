import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:foo/src/core/failures.dart';

part 'value_state.store.g.dart';

/// É uma classe que representa um valor de uma variável. Ela é utilizada para
/// adicionar estados a uma variável, sendo eles o `isLoading` e o `hasFailure`.
///
/// Também guarda o erro ocorrido, caso o `hasFailure` seja `true`. `failure`
///
/// Outra coisa que essa classe auxilia é com a execução de um [Future],
/// Com o método `execute` dessa classe, você pode enviar uma função que será
/// retornada por um [Future] e que será executada. Enquanto executa a função,
/// ele automaticamente coloca em estado de `isLoading` e caso ocorra algum
/// erro, ele seta o error no `failure` e fica em estado de `hasFailure`.
/// Assim como, coloca automaticamente o estado de `isLoading` para `false`.
class ValueState<State> = _ValueStateBase<State> with _$ValueState;

abstract class _ValueStateBase<ValueType> with Store {
  final ValueType _initialValue;

  _ValueStateBase(this._initialValue) : _value = _initialValue;

  @observable
  ValueType _value;
  @observable
  Failure? _failure;
  @observable
  var _isLoading = false;

  /// Retorna o valor guardado nesse [Store].
  @computed
  ValueType get value => _value;

  /// Retorna o erro ocorrido, pode ser um [None], ou seja vazio, precisa sempre
  /// verificar se o `hasFailure` está `true`.
  @computed
  Failure? get failure => _failure;

  /// Retorna `true` se está em loading, `false` caso contrário.
  @computed
  bool get isLoading => _isLoading;

  /// Retorna `true` se a variável `failure` não está vazio.
  /// Retorna `false` caso contrário.
  @computed
  bool get hasFailure => _failure != null;

  /// Verifica se não há erro, se não está carregando e se o valor é `!= null`
  @computed
  bool get isSuccessWithValue => isSuccess && value != null;

  /// Verifica se não há erro e se não está carregando
  @computed
  bool get isSuccess => !hasFailure && !isLoading;

  /// Seta o valor guardado nesse [Store].
  @action
  void setValue(ValueType value) {
    _value = value;
  }

  /// Seta o erro ocorrido, podendo ser `null` caso não haja mais erro.
  @action
  void setFailure(Failure? error) {
    _failure = error;
  }

  /// Seta o estado de `isLoading`.
  @action
  void setLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  /// Executa uma função que retorna um [Future] com o valor que será guardado.
  /// Enquanto executa a função, ele automaticamente coloca em estado de
  /// `isLoading` e caso ocorra algum erro, ele seta o error no `failure` e fica
  /// em estado de `hasFailure`.
  /// Assim como, coloca automaticamente o estado de `isLoading` para `false`.
  Future<void> execute(Future<Either<Failure, ValueType>> Function() exec,
      {Duration? timeout, bool shouldSetToInitialValue = true}) async {
    setLoading(true);
    setFailure(null);
    if (shouldSetToInitialValue) setValue(_initialValue);
    try {
      final res = await exec().timeout(timeout ?? const Duration(milliseconds: 15000));
      res.fold(
        (error) => setFailure(error),
        (result) => setValue(result),
      );
    } on TimeoutException catch (_) {
      setFailure(kAppTimeoutFailure);
    } catch (e) {
      setFailure(kAppFailure);
    } finally {
      setLoading(false);
    }
  }

  Either<Failure, ValueType> toEither() {
    if (failure != null) return Left(failure!);
    return Right(value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueState<ValueType> &&
        other._value == _value &&
        other._isLoading == _isLoading &&
        other._failure == _failure;
  }

  @override
  int get hashCode => _value.hashCode ^ _isLoading.hashCode ^ _failure.hashCode;
}
