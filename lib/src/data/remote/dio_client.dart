import 'package:dio/dio.dart';
import 'package:foo/src/core/constants.dart';

import 'interceptors/auth_interceptor.dart';

class DioClient {
  final Dio _dio;
  final AuthInterceptor _authInterceptor;

  DioClient(this._dio, this._authInterceptor) {
    _dio.options.connectTimeout = 10000;
    _dio.options.sendTimeout = 10000;
    _dio.options.receiveTimeout = 10000;

    _dio.interceptors.add(LogInterceptor());
    _dio.interceptors.add(_authInterceptor);
    _dio.options.baseUrl = flavor.baseUrl;
  }

  Future<T?> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final res = await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: extra,
      ),
    );
    return res.data;
  }

  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final res = await _dio.get<T>(
      path,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: extra,
      ),
    );
    return res.data;
  }

  Future<T?> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final res = await _dio.patch<T>(
      path,
      data: data,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: extra,
      ),
    );
    return res.data;
  }

  Future<T?> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final res = await _dio.post<T>(
      path,
      data: data,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: extra,
      ),
    );
    return res.data;
  }

  Future<T?> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final res = await _dio.put<T>(
      path,
      data: data,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: extra,
      ),
    );
    return res.data;
  }
}
