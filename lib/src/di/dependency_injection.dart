import 'package:dio/dio.dart';
import 'package:foo/src/data/remote/dio_client.dart';
import 'package:foo/src/data/remote/interceptors/auth_interceptor.dart';
import 'package:foo/src/modules/logger/domain/log.usecase.dart';
import 'package:get_it/get_it.dart';

final _getIt = GetIt.instance;

T getIt<T extends Object>() => _getIt.get<T>();

Future<void> registerDependencies() async {
  _getIt.registerSingleton<LogUseCase>(const LogUseCase());
  _getIt.registerLazySingleton(
    () {
      final dio = Dio();
      // TODO Add token
      return DioClient(dio, AuthInterceptor(dio, () async => '', () async => ''));
    },
  );
}
