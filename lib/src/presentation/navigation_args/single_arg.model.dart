import 'package:foo/src/presentation/navigation_args/navigation_arg.model.dart';

class SingleArg<T> extends NavigationArg<SingleArg<T>> {
  final T data;

  const SingleArg(this.data) : super();

  @override
  List<Object?> get props => [data];
}
