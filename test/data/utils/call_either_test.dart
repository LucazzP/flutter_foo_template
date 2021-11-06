import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foo/src/core/exceptions.dart';
import 'package:foo/src/core/failures.dart';
import 'package:foo/src/data/utils/call_either.dart';
import 'package:foo/src/extensions/call_either.ext.dart';

Future<void> main() async {
  void testAsFuncAndAsExt<Result, Response>(
    String nameOfTest,
    Future<Response> Function() request,
    Either<Failure, Response> response, {
    Future<Either<Failure, Result>> Function(Response res)? processResponse,
    Failure Function(dynamic error)? onError,
  }) {
    group(nameOfTest, () {
      test('calling as extension', () async {
        final result =
            await (request).either<Result>(processResponse: processResponse, onError: onError);
        expect(result, equals(response));
      });
      test('calling normally', () async {
        final result = await callEither<Result, Response>(request,
            processResponse: processResponse, onError: onError);
        expect(result, equals(response));
      });
    });
  }

  group('Check CallEither happy path', () {
    const response = 'Response';

    testAsFuncAndAsExt<String, String>(
      'verify with only a request',
      () async => response,
      const Right(response),
    );
    testAsFuncAndAsExt<String, String>(
      'verify with a request and a proccessResponse',
      () async => response,
      const Right('ProcessedResponse'),
      processResponse: (res) async => const Right('ProcessedResponse'),
    );
    testAsFuncAndAsExt<String, String>(
      'verify with a request and a proccessResponse with Left response',
      () async => response,
      const Left(kServerFailure),
      processResponse: (res) async => const Left(kServerFailure),
    );
  });
  group('Check CallEither unhappy path', () {
    testAsFuncAndAsExt<String, String>(
      'verify with a request, proccessResponse and onError',
      () async => throw Exception(),
      const Left(kCacheFailure),
      processResponse: (res) async => const Left(kServerFailure),
      onError: (error) => error is Exception ? kCacheFailure : kServerFailure,
    );
    group('verify with a request the connection failure', () {
      testAsFuncAndAsExt<String, String>(
        'with APITimeoutException',
        () async => throw APITimeoutException(),
        const Left(kConnectionFailure),
      );
      testAsFuncAndAsExt<String, String>(
        'with APINotConnectedException',
        () async => throw APINotConnectedException(),
        const Left(kConnectionFailure),
      );
      testAsFuncAndAsExt<String, String>(
        'with APIClientNotLoggedException',
        () async => throw APIClientNotLoggedException(),
        const Left(kExpiredSession),
      );
      testAsFuncAndAsExt<String, String>(
        'with BVAPIGenericErrorException',
        () async => throw const APIGenericErrorException(''),
        const Left(kServerFailure),
      );
    });
    testAsFuncAndAsExt<String, String>(
      'verify with a request, and onError, should map all api exceptions before',
      () async => throw APINotConnectedException(),
      const Left(kConnectionFailure),
      onError: (error) => error is Exception ? kCacheFailure : kServerFailure,
    );
  });
}
