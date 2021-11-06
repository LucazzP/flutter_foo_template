import 'package:dartz/dartz.dart';

import 'failures.dart';

/// Classe para definição de use-cases
/// seguindo as definições do _clean architecture_
abstract class BaseUseCase<Data, Param> {
  Future<Either<Failure, Data>> call(Param p);
}
