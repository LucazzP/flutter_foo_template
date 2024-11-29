// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FormStore<T> on _FormStoreBase<T>, Store {
  Computed<T>? _$valueComputed;

  @override
  T get value => (_$valueComputed ??=
          Computed<T>(() => super.value, name: '_FormStoreBase.value'))
      .value;
  Computed<String>? _$valueStringComputed;

  @override
  String get valueString =>
      (_$valueStringComputed ??= Computed<String>(() => super.valueString,
              name: '_FormStoreBase.valueString'))
          .value;
  Computed<bool>? _$hasValueComputed;

  @override
  bool get hasValue => (_$hasValueComputed ??=
          Computed<bool>(() => super.hasValue, name: '_FormStoreBase.hasValue'))
      .value;

  late final _$_valueAtom =
      Atom(name: '_FormStoreBase._value', context: context);

  @override
  T get _value {
    _$_valueAtom.reportRead();
    return super._value;
  }

  @override
  set _value(T value) {
    _$_valueAtom.reportWrite(value, super._value, () {
      super._value = value;
    });
  }

  late final _$errorAtom = Atom(name: '_FormStoreBase.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$_FormStoreBaseActionController =
      ActionController(name: '_FormStoreBase', context: context);

  @override
  void setValue(T value) {
    final _$actionInfo = _$_FormStoreBaseActionController.startAction(
        name: '_FormStoreBase.setValue');
    try {
      return super.setValue(value);
    } finally {
      _$_FormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? error) {
    final _$actionInfo = _$_FormStoreBaseActionController.startAction(
        name: '_FormStoreBase.setError');
    try {
      return super.setError(error);
    } finally {
      _$_FormStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
error: ${error},
value: ${value},
valueString: ${valueString},
hasValue: ${hasValue}
    ''';
  }
}
