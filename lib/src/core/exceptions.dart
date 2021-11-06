import 'package:equatable/equatable.dart';

class APIClientNotLoggedException extends ExceptionEquatable {}

class APINotConnectedException extends ExceptionEquatable {}

class APIBadRequestException extends ExceptionEquatable {}

class APIForbiddenException extends ExceptionEquatable {}

class APITimeoutException extends ExceptionEquatable {}

class APIGenericErrorException extends ExceptionEquatable {
  final String message;

  const APIGenericErrorException(this.message);

  @override
  List<Object> get props => [message];
}

class ExceptionEquatable extends Equatable implements Exception {
  const ExceptionEquatable();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}
