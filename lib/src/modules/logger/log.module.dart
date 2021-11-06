import 'package:flutter_modular/flutter_modular.dart';

import 'domain/log.usecase.dart';

class LogModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.factory<LogUseCase>((i) => const LogUseCase(), export: true),
  ];

  @override
  final List<ModularRoute> routes = [];
}
