import 'package:equatable/equatable.dart';

class ExampleEntity extends Equatable {
  final String name;

  const ExampleEntity(this.name);

  @override
  List<Object?> get props => [name];
}