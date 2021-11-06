import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:foo/src/core/flavor/flavor_config.model.dart';
import 'package:foo/src/data/remote/interceptors/auth_interceptor.dart';
import 'package:foo/src/modules/logger/log.module.dart';

import 'data/remote/dio_client.dart';
import 'modules/home/home_module.dart';

class AppModule extends Module {
  final Flavor flavor;
  AppModule(this.flavor);

  @override
  final List<Module> imports = [
    LogModule(),
  ];

  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => Dio()),
    // TODO Add token
    Bind.lazySingleton((i) => AuthInterceptor(i(), () async => '', () async => '')),
    Bind.lazySingleton((i) => DioClient(i(), i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
  ];
}
