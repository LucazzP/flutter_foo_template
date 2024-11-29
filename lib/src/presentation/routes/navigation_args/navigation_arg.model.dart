import 'package:equatable/equatable.dart';

abstract class NavigationArg<T> extends Equatable {
  const NavigationArg();

  T get arg => this as T;

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}
