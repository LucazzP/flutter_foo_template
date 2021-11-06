import 'package:mobx/mobx.dart';

part 'value.store.g.dart';

/// É uma classe que representa um valor de uma variável. Ela é utilizada para
/// facilitar a utilização de `observable` em um [Store], implementando
/// previamente o `@observable` e o `@action` com o `setValue`.
class ValueStore<ValueType> = _ValueStoreBase<ValueType> with _$ValueStore;

abstract class _ValueStoreBase<ValueType> with Store {
  _ValueStoreBase(ValueType initialValue) : _value = initialValue;

  @observable
  ValueType _value;

  /// Retorna o valor guardado nesse [Store].
  @computed
  ValueType get value => _value;

  /// Seta o valor guardado nesse [Store].
  @action
  void setValue(ValueType value) {
    _value = value;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueStore<ValueType> &&
        other._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;
}
