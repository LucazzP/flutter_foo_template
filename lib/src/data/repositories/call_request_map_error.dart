import 'dart:async';

import 'package:foo/src/core/exceptions.dart';
import 'package:foo/src/core/failures.dart';

Future<Result> callRequestMapError<Result, Response>(
  FutureOr<Response> Function() request, {
  FutureOr<Result> Function(Response res)? processResponse,
  Failure Function(dynamic error)? onError,
}) async {
  assert(
    Response == Result || (!(Response == Result) && processResponse != null),
    'You need to specify the `processResponse` when the types are different',
  );
  processResponse ??= (value) async => value as Result;
  try {
    final response = await request();
    final result = await processResponse(response);
    return result;
  } catch (e) {
    throw _mapError<Result>(e, onError);
  }
}

Failure _mapError<Result>(dynamic e, Failure Function(dynamic error)? onError) {
  if (e is APITimeoutException || e is APINotConnectedException) {
    return kConnectionFailure;
  }
  if (e is APIClientNotLoggedException) {
    return kExpiredSession;
  }
  if (e is APIInvalidLoginCredentialsException) {
    return kCredentialsFailure;
  }
  if (e is Exception) {
    if (e.toString().contains('JWT expired')) {
      return kExpiredSession;
    }
  }
  if (e is Failure) {
    return (e);
  }
  if (onError != null) {
    return (onError(e));
  }
  return kServerFailure;
}
