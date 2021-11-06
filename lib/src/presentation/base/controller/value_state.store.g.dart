// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'value_state.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ValueState<ValueType> on _ValueStateBase<ValueType>, Store {
  Computed<ValueType>? _$valueComputed;

  @override
  ValueType get value => (_$valueComputed ??=
          Computed<ValueType>(() => super.value, name: '_ValueStateBase.value'))
      .value;
  Computed<Failure?>? _$failureComputed;

  @override
  Failure? get failure =>
      (_$failureComputed ??= Computed<Failure?>(() => super.failure,
              name: '_ValueStateBase.failure'))
          .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: '_ValueStateBase.isLoading'))
          .value;
  Computed<bool>? _$hasFailureComputed;

  @override
  bool get hasFailure =>
      (_$hasFailureComputed ??= Computed<bool>(() => super.hasFailure,
              name: '_ValueStateBase.hasFailure'))
          .value;
  Computed<bool>? _$isSuccessWithValueComputed;

  @override
  bool get isSuccessWithValue => (_$isSuccessWithValueComputed ??=
          Computed<bool>(() => super.isSuccessWithValue,
              name: '_ValueStateBase.isSuccessWithValue'))
      .value;
  Computed<bool>? _$isSuccessComputed;

  @override
  bool get isSuccess =>
      (_$isSuccessComputed ??= Computed<bool>(() => super.isSuccess,
              name: '_ValueStateBase.isSuccess'))
          .value;

  final _$_valueAtom = Atom(name: '_ValueStateBase._value');

  @override
  ValueType get _value {
    _$_valueAtom.reportRead();
    return super._value;
  }

  @override
  set _value(ValueType value) {
    _$_valueAtom.reportWrite(value, super._value, () {
      super._value = value;
    });
  }

  final _$_failureAtom = Atom(name: '_ValueStateBase._failure');

  @override
  Failure? get _failure {
    _$_failureAtom.reportRead();
    return super._failure;
  }

  @override
  set _failure(Failure? value) {
    _$_failureAtom.reportWrite(value, super._failure, () {
      super._failure = value;
    });
  }

  final _$_isLoadingAtom = Atom(name: '_ValueStateBase._isLoading');

  @override
  bool get _isLoading {
    _$_isLoadingAtom.reportRead();
    return super._isLoading;
  }

  @override
  set _isLoading(bool value) {
    _$_isLoadingAtom.reportWrite(value, super._isLoading, () {
      super._isLoading = value;
    });
  }

  final _$_ValueStateBaseActionController =
      ActionController(name: '_ValueStateBase');

  @override
  void setValue(ValueType value) {
    final _$actionInfo = _$_ValueStateBaseActionController.startAction(
        name: '_ValueStateBase.setValue');
    try {
      return super.setValue(value);
    } finally {
      _$_ValueStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFailure(Failure? error) {
    final _$actionInfo = _$_ValueStateBaseActionController.startAction(
        name: '_ValueStateBase.setFailure');
    try {
      return super.setFailure(error);
    } finally {
      _$_ValueStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool isLoading) {
    final _$actionInfo = _$_ValueStateBaseActionController.startAction(
        name: '_ValueStateBase.setLoading');
    try {
      return super.setLoading(isLoading);
    } finally {
      _$_ValueStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
failure: ${failure},
isLoading: ${isLoading},
hasFailure: ${hasFailure},
isSuccessWithValue: ${isSuccessWithValue},
isSuccess: ${isSuccess}
    ''';
  }
}
