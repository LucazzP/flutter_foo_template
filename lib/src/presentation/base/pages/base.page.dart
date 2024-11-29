import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:foo/src/presentation/base/controller/base.store.dart';
import 'package:foo/src/presentation/base/pages/reaction.dart';
import 'package:mobx/mobx.dart' as mobx;

abstract class BaseState<T extends StatefulWidget, S extends BaseStore> extends State<T> {
  late final S controller;

  S createController();

  @visibleForTesting
  @nonVirtual
  final List<mobx.ReactionDisposer> disposers = [];

  /// Roda a função imediatamente ao abrir a page e também quando algum dos
  /// observables for alterado.
  final List<void Function()> autoRun = [];

  /// Roda a função sempre que algum dos observables for alterado.
  final List<Reaction> reaction = [];

  /// A diferença entre o `when` e o `reaction` é que esse roda apenas uma vez,
  /// depois que a condição for satisfeita, ele sofre automaticamente um dispose
  ///
  /// item1: Condição para rodar a outra função (precisa possuir um observer
  /// para a função rodar automaticamente)
  ///
  /// item2: Função que irá executar caso a condição seja verdadeira.
  final List<(bool Function(mobx.Reaction _), void Function())> when = [];

  @override
  @mustCallSuper
  void initState() {
    controller = createController();
    initStore();
    disposers.addAll(autoRun.map((func) => mobx.autorun((_) => func())));
    disposers.addAll(reaction.map((reaction) => reaction.toReaction()));
    disposers.addAll(
      when.map((tuple) => mobx.when(tuple.$1, tuple.$2)),
    );
    super.initState();
  }

  @mustCallSuper
  void initStore() {
    controller.init();
  }

  @visibleForTesting
  void disposeFunc() {
    for (final dispose in disposers) {
      dispose();
    }
    controller.dispose();
  }

  @override
  void dispose() {
    disposeFunc();
    super.dispose();
  }
}
