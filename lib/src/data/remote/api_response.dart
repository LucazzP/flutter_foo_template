import 'package:dio/dio.dart';

class ApiResponse<T> {
  final T data;

  /// Http status code.
  final int statusCode;

  /// Returns the reason phrase associated with the status code.
  /// The reason phrase must be set before the body is written
  /// to. Setting the reason phrase after writing to the body.
  final String statusMessage;

  /// Response headers.
  final Map<String, List<String>> headers;

  final bool isSuccess;

  const ApiResponse({
    required this.data,
    this.statusCode = 200,
    this.statusMessage = '',
    this.headers = const {},
  }) : isSuccess = statusCode >= 200 && statusCode < 300;

  factory ApiResponse.fromResponseDio(Response res) => ApiResponse(
        data: res.data,
        headers: res.headers.map,
        statusCode: res.statusCode ?? 200,
        statusMessage: res.statusMessage ?? '',
      );
}
