import 'package:dartz/dartz.dart';
import 'package:foo/src/core/failures.dart';
import 'package:foo/src/data/utils/call_either.dart';

extension CallEither<Response> on Future<Response> Function() {
  Future<Either<Failure, Result>> either<Result>({
    Future<Either<Failure, Result>> Function(Response res)? processResponse,
    Failure Function(dynamic error)? onError,
  }) =>
      callEither<Result, Response>(
        this,
        processResponse: processResponse,
        onError: onError,
      );
}
