// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'value_state.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ValueState<ValueType> on _ValueStateBase<ValueType>, Store {
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
  Computed<PageDataState>? _$pageDataStateComputed;

  @override
  PageDataState get pageDataState => (_$pageDataStateComputed ??=
          Computed<PageDataState>(() => super.pageDataState,
              name: '_ValueStateBase.pageDataState'))
      .value;

  late final _$_valueAtom =
      Atom(name: '_ValueStateBase._value', context: context);

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

  late final _$_failureAtom =
      Atom(name: '_ValueStateBase._failure', context: context);

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

  late final _$_isLoadingAtom =
      Atom(name: '_ValueStateBase._isLoading', context: context);

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

  late final _$_alreadyExecutedAtom =
      Atom(name: '_ValueStateBase._alreadyExecuted', context: context);

  @override
  bool get _alreadyExecuted {
    _$_alreadyExecutedAtom.reportRead();
    return super._alreadyExecuted;
  }

  @override
  set _alreadyExecuted(bool value) {
    _$_alreadyExecutedAtom.reportWrite(value, super._alreadyExecuted, () {
      super._alreadyExecuted = value;
    });
  }

  late final _$_ValueStateBaseActionController =
      ActionController(name: '_ValueStateBase', context: context);

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
  void setFailure(Failure? error, {Exception? e, StackTrace? st}) {
    final _$actionInfo = _$_ValueStateBaseActionController.startAction(
        name: '_ValueStateBase.setFailure');
    try {
      return super.setFailure(error, e: e, st: st);
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
  void setAlreadyExecuted(bool alreadyExecuted) {
    final _$actionInfo = _$_ValueStateBaseActionController.startAction(
        name: '_ValueStateBase.setAlreadyExecuted');
    try {
      return super.setAlreadyExecuted(alreadyExecuted);
    } finally {
      _$_ValueStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
hasFailure: ${hasFailure},
isSuccessWithValue: ${isSuccessWithValue},
isSuccess: ${isSuccess},
pageDataState: ${pageDataState}
    ''';
  }
}
