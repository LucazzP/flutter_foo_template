import 'package:foo/src/domain/entities/example.entity.dart';

abstract class ExampleRepo {
  Future<ExampleEntity> exampleMethod();
}