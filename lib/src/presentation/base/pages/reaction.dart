import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart' as mobx;

class Reaction<T> {
  final T Function() reaction;
  final void Function(T value) effect;

  Reaction(this.reaction, this.effect);

  mobx.ReactionDisposer toReaction() => mobx.reaction<T>((_) => reaction(), effect);

  T? _lastResultReaction;

  @visibleForTesting
  void execute() {
    final result = reaction();
    if (result != _lastResultReaction) {
      effect(result);
      _lastResultReaction = result;
    }
  }
}
