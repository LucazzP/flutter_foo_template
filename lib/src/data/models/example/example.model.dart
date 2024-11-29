import 'package:foo/src/domain/entities/example.entity.dart';

extension ExampleModel on ExampleEntity {
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  static ExampleEntity fromMap(Map<String, dynamic> map) {
    return ExampleEntity(
      map['name'],
    );
  }
}
