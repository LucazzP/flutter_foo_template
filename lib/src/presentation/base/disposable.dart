import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart' as get_it;

abstract mixin class Disposable implements get_it.Disposable {
  const Disposable();

  @mustCallSuper
  FutureOr<void> dispose();

  @override
  @protected
  @nonVirtual
  FutureOr onDispose() => dispose();
}
