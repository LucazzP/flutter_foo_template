import 'package:foo/src/data/data_sources/local/hive_client.dart';
import 'package:foo/src/data/data_sources/remote/dio_client.dart';
import 'package:foo/src/data/models/example/example.model.dart';
import 'package:foo/src/data/repositories/call_request_map_error.dart';
import 'package:foo/src/domain/entities/example.entity.dart';
import 'package:foo/src/domain/repositories/example.repo.dart';

class ExampleRepoImpl implements ExampleRepo {
  final DioClient remoteDataSource;
  final HiveClient localDataSource;

  ExampleRepoImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<ExampleEntity> exampleMethod() async {
    return callRequestMapError(
      () {
        return {
          'name': 'Example',
        };
      },
      processResponse: (res) => ExampleModel.fromMap(res),
    );
  }
}
