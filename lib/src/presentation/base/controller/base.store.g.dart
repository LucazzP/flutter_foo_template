// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BaseStore on _BaseStoreBase, Store {
  Computed<Iterable<ValueState<dynamic>>>? _$statesComputed;

  @override
  Iterable<ValueState<dynamic>> get states => (_$statesComputed ??=
          Computed<Iterable<ValueState<dynamic>>>(() => super.states,
              name: '_BaseStoreBase.states'))
      .value;
  Computed<Failure?>? _$failureComputed;

  @override
  Failure? get failure =>
      (_$failureComputed ??= Computed<Failure?>(() => super.failure,
              name: '_BaseStoreBase.failure'))
          .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(() => super.isLoading,
              name: '_BaseStoreBase.isLoading'))
          .value;
  Computed<bool>? _$hasFailureComputed;

  @override
  bool get hasFailure =>
      (_$hasFailureComputed ??= Computed<bool>(() => super.hasFailure,
              name: '_BaseStoreBase.hasFailure'))
          .value;

  @override
  String toString() {
    return '''
states: ${states},
failure: ${failure},
isLoading: ${isLoading},
hasFailure: ${hasFailure}
    ''';
  }
}
