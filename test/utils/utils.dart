import 'package:dartz/dartz.dart';
import 'package:foo/src/presentation/base/pages/reaction.dart';

void runAutoRuns(List<void Function()> autoRun) {
  for (final func in autoRun) {
    func();
  }
}

void runReactions(List<Reaction> reaction) {
  for (final reaction in reaction) {
    reaction.execute();
  }
}

void runWhens(List<Tuple2<bool Function(), void Function()>> whens) {
  for (final tuple in whens) {
    if (tuple.value1()) {
      tuple.value2();
    }
  }
}
