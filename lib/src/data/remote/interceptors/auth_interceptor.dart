import 'package:dio/dio.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final Future<String> Function() getAuthToken;
  final Future<String> Function() getAuthTokenRefreshed;

  AuthInterceptor(Dio _dio, this.getAuthToken, this.getAuthTokenRefreshed)
      : super(
          onError: (error, handler) async {
            if (error.response?.statusCode == 403) {
              _dio.interceptors.requestLock.lock();
              _dio.interceptors.responseLock.lock();
              final options = error.response?.requestOptions ?? error.requestOptions;
              options.headers['Authorization'] = 'Bearer ${await getAuthTokenRefreshed()}';

              _dio.interceptors.requestLock.unlock();
              _dio.interceptors.responseLock.unlock();
              handler.resolve(await _dio.request(
                options.path,
                options: Options(
                  method: options.method,
                  sendTimeout: options.sendTimeout,
                  receiveTimeout: options.receiveTimeout,
                  extra: options.extra,
                  headers: options.headers,
                  responseType: options.responseType,
                  contentType: options.contentType,
                  validateStatus: options.validateStatus,
                  receiveDataWhenStatusError: options.receiveDataWhenStatusError,
                  followRedirects: options.followRedirects,
                  maxRedirects: options.maxRedirects,
                  requestEncoder: options.requestEncoder,
                  responseDecoder: options.responseDecoder,
                  listFormat: options.listFormat,
                ),
              ));
            }
            handler.next(error);
          },
          onRequest: (options, handler) async {
            options.headers['Authorization'] = 'Bearer ${await getAuthToken()}';
            handler.next(options);
          },
        );
}
