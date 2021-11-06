// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'value.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ValueStore<ValueType> on _ValueStoreBase<ValueType>, Store {
  Computed<ValueType>? _$valueComputed;

  @override
  ValueType get value => (_$valueComputed ??=
          Computed<ValueType>(() => super.value, name: '_ValueStoreBase.value'))
      .value;

  final _$_valueAtom = Atom(name: '_ValueStoreBase._value');

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

  final _$_ValueStoreBaseActionController =
      ActionController(name: '_ValueStoreBase');

  @override
  void setValue(ValueType value) {
    final _$actionInfo = _$_ValueStoreBaseActionController.startAction(
        name: '_ValueStoreBase.setValue');
    try {
      return super.setValue(value);
    } finally {
      _$_ValueStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
