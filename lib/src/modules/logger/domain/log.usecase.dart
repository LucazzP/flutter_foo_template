import 'dart:developer';

class LogUseCase {
  const LogUseCase();

  Future<void> call(String message, {Exception? exception, StackTrace? stackTrace}) async {
    log(message, error: exception, stackTrace: stackTrace);
  }
}
