// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foo/src/presentation/base/disposable.dart';
import 'package:mobx/mobx.dart';

part 'form_store.g.dart';

class FormStore<T> = _FormStoreBase<T> with _$FormStore;

abstract class _FormStoreBase<T> with Store, Disposable {
  final FutureOr<String?> Function(T value) validator;
  late final String Function(T value)? valueToString;
  late final T Function(String value)? stringToValue;
  TextEditingController? _controller;

  _FormStoreBase({
    required this.validator,
    required T value,
    String Function(T value)? valueToString,
    T Function(String value)? stringToValue,
  }) : _value = value {
    // if T is not String, value, valueToString and stringToValue are not required
    if (T == String) {
      this.valueToString = valueToString ?? (T value) => value as String? ?? '';
      this.stringToValue = stringToValue ?? (String value) => value as T;
      return;
    }
    if (null is T && valueToString == null && stringToValue == null) {
      this.valueToString = valueToString ?? (T value) => (value as String?) ?? '';
      this.stringToValue = stringToValue ?? (String value) => value as T;
      return;
    }
    this.valueToString = valueToString;
    this.stringToValue = stringToValue;
  }

  TextEditingController get controller {
    assert(stringToValue != null && valueToString != null,
        'valueToString and stringToValue are required when T is not String and are using the TextEditingController');
    final textController = _controller ?? TextEditingController(text: valueString);
    if (_controller == null) {
      _controller = textController;
      textController.addListener(() {
        if (textController.text != value) {
          try {
            setValue(stringToValue!(textController.text));
          } catch (e) {
            setError('Invalid value, e: $e');
          }
        }
      });
    }
    return textController;
  }

  Future<bool> validate() async {
    final error = await validator(value);
    setError(error);
    return error == null;
  }

  @observable
  T _value;

  @computed
  T get value => _value;

  set value(T value) {
    setValue(value);
  }

  @computed
  String get valueString => valueToString!(value);

  @computed
  bool get hasValue => valueString.isNotEmpty;

  @observable
  String? error;

  @action
  void setValue(T value) {
    _value = value;
    if (_controller != null) {
      if (controller.text != valueString) controller.text = valueString;
    }
    if (error != null) validate();
  }

  @action
  void setError(String? error) {
    this.error = error;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
  }
}
