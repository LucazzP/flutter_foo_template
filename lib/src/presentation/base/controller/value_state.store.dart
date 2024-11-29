import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:foo/src/core/failures.dart';
import 'package:foo/src/core/page_data_state.dart';
import 'package:foo/src/di/dependency_injection.dart';
import 'package:foo/src/domain/use_cases/logger/log.usecase.dart';
import 'package:foo/src/presentation/base/disposable.dart';
import 'package:mobx/mobx.dart';

part 'value_state.store.g.dart';

/// It is a class that represents a variable value. It is used to
/// add states to a variable, namely `isLoading` and` hasFailure`.
///
/// It also keeps track of the error that occurred if` hasFailure` is` true`. `failure`
///
/// Another thing that this class helps with is executing a [Future],
/// With this class `execute` method, you can send a function that will be
/// returned by a [Future] and that will be executed. While executing the function,
/// it automatically puts in state of `isLoading` and if any
/// error occurs, it sets the error on `failure` and is in the state of` hasFailure`.
/// As well as automatically setting the state of `isLoading` to` false`.
class ValueState<State> = _ValueStateBase<State> with _$ValueState<State>;

abstract class _ValueStateBase<ValueType> extends Disposable with Store {
  final ValueType _initialValue;
  Future<void> executeFuture = Future.value();
  final void Function(ValueType oldValue, ValueType value)? onValueChanged;

  _ValueStateBase(this._initialValue, {this.onValueChanged}) : _value = _initialValue;

  @observable
  ValueType _value;
  @observable
  Failure? _failure;
  @observable
  var _isLoading = false;
  @observable
  bool _alreadyExecuted = false;

  /// Returns the value stored in this [Store].
  @computed
  ValueType get value => _value;

  /// Returns the error that occurred, it can be a [None], ie empty, you always need
  /// check if `hasFailure` is `true`.
  @computed
  Failure? get failure => _failure;

  /// Returns `true` if it is in loading, `false` otherwise.
  @computed
  bool get isLoading => _isLoading;

  /// Returns `true` if the variable `failure` is not empty.
  /// Returns `false` otherwise.
  @computed
  bool get hasFailure => _failure != null;

  /// Check if there's no error, if it's not loading and if the value is `!= null`
  @computed
  bool get isSuccessWithValue => isSuccess && value != null;

  /// Check if there is no error, it is not loading and already executed.
  @computed
  bool get isSuccess => _alreadyExecuted && !hasFailure && !isLoading;

  bool get _isEmpty => value == null || (value is List && (value as List).isEmpty);

  @computed
  PageDataState get pageDataState {
    if (isLoading) {
      if (_alreadyExecuted || !_isEmpty) return PageDataState.updating;
      return PageDataState.loading;
    }
    if (hasFailure) {
      if (_alreadyExecuted || !_isEmpty) return PageDataState.loadingFailed;
      return PageDataState.updatingFailed;
    }
    if (_isEmpty) return PageDataState.empty;
    return PageDataState.populated;
  }

  /// Get the value stored in this [Store].
  @action
  void setValue(ValueType value) {
    if (value == _value) return;
    final oldValue = _value;
    _value = value;
    onValueChanged?.call(oldValue, value);
  }

  set value(ValueType value) => setValue(value);

  /// Set the error occurred, can be `null` if there is no error.
  @action
  void setFailure(Failure? error, {Exception? e, StackTrace? st}) {
    _failure = error;
    if (error != null) {
      getIt<LogUseCase>().call(error.toString(), exception: e, stackTrace: st);
    }
  }

  /// Sets the `isLoading` state.
  @action
  void setLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  /// Sets the `alreadyExecuted` state.
  @action
  void setAlreadyExecuted(bool alreadyExecuted) {
    _alreadyExecuted = alreadyExecuted;
  }

  /// Executes a function that returns a [Future] with the value to be saved.
  /// While executing the function, it automatically puts it in the state of
  /// `isLoading` and if an error occurs, it sets the error in the `failure` and stays
  /// in `hasFailure` state.
  /// As well as, it automatically puts the `isLoading` state to` false`.
  Future<ValueType> execute(
    Future<ValueType> Function() exec, {
    Duration? timeout,
    bool shouldSetToInitialValue = false,
    bool shouldSetLoading = true,
    bool shouldSetValue = true,
    Failure Function(Object e, StackTrace st)? failureMapper,
  }) {
    executeFuture = () async {
      if (shouldSetLoading) setLoading(true);
      setFailure(null);
      if (shouldSetToInitialValue) setValue(_initialValue);
      try {
        final res = await exec().timeout(timeout ?? const Duration(seconds: 30));
        if (shouldSetValue) setValue(res);
      } on TimeoutException catch (_) {
        setFailure(kAppTimeoutFailure);
      } catch (e, st) {
        setFailure(failureMapper?.call(e, st) ?? kAppFailure);
      } finally {
        if (shouldSetLoading) setLoading(false);
      }
      setAlreadyExecuted(true);
    }();
    return executeFuture.then((_) => this.value);
  }

  final List<VoidCallback> _disposers = [];

  _MappedValueState<T, ValueType> map<T>(T Function(ValueType value) mapper) {
    final mappedState = _MappedValueState<T, ValueType>(this as ValueState<ValueType>, mapper);
    _disposers.add(mappedState.dispose);
    return mappedState;
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

  @override
  void dispose() {
    while (_disposers.isNotEmpty) {
      _disposers.removeLast().call();
    }
  }
}

class _MappedValueState<T, ValueType> extends ValueState<T> with Store {
  final ValueState<ValueType> _valueState;
  final T Function(ValueType value) _mapper;
  ReactionDisposer? _reactionDisposer;

  _MappedValueState(this._valueState, this._mapper) : super(_mapper(_valueState.value)) {
    _reactionDisposer = reaction((_) {
      return _valueState.value;
    }, (value) => setValue(_mapper(value)));
  }

  @override
  void dispose() {
    _reactionDisposer?.call();
    super.dispose();
  }
}
