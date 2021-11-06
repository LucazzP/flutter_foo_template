import 'package:dartz/dartz.dart' hide Bind;
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foo/src/core/failures.dart';
import 'package:foo/src/extensions/context.ext.dart';
import 'package:foo/src/presentation/base/pages/base.page.dart';
import 'package:foo/src/presentation/base/pages/reaction.dart' as react;
import 'package:foo/src/presentation/styles/app_color_scheme.dart';
import 'package:mobx/mobx.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';

import '../../../../mocks/controller.mocks.dart';
import '../../../../utils/test_widgets.dart';

part 'sample_base.page.dart';
part 'sample_modified_base.page.dart';

final _appBar = AppBar();
const _sampleWidgetKey = Key('sampleWidget');
var _supportScrollView = false;
var _buildTimes = 0;

class ReactionDisposerMock extends Mock implements ReactionDisposer {}

Future<void> main() async {
  Color? expectedBgColor;
  const EdgeInsets expectedPadding = EdgeInsets.symmetric(vertical: 16, horizontal: 16);
  late BuildContext context;
  late ControllerTest _controller;
  final reactionDisposer = ReactionDisposerMock();

  setUpAll(() {
    _controller = ControllerTest();
  });

  tearDown(() {
    _controller.dispose();
    reset(reactionDisposer);
  });

  setUp(() {
    _buildTimes = 0;
    _supportScrollView = false;
    initModule(SampleBaseModule(), replaceBinds: [
      Bind.instance<ControllerTest>(_controller),
    ]);
  });

  Future<_SampleBasePageState> buildPage(WidgetTester tester, {bool? asSmallDevice}) async {
    final key = GlobalKey<_SampleBasePageState>();
    final page = _SampleBasePage(key: key);
    context = await tester.pumpPage(
      page,
      asSmallDevice: asSmallDevice,
    );
    expectedBgColor = AppColorScheme.colorScheme.background;
    return key.currentState!;
  }

  Future<_SampleModifiedBasePageState> buildModifiedPage(WidgetTester tester) async {
    expectedBgColor = const Color(0x12345678);
    final key = GlobalKey<_SampleModifiedBasePageState>();
    final page = _SampleModifiedBasePage(key: key);
    context = await tester.pumpPage(page);
    return key.currentState!;
  }

  group('BVBasePage', () {
    group('Check default value of', () {
      testWidgets('background color is the AppColorScheme.colorScheme.background', (tester) async {
        final page = await buildPage(tester);

        expect(page.bgColor, equals(expectedBgColor));
        final scaffold = tester.firstWidget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(expectedBgColor));
      });

      group('defaultPadding is EdgeInsets.symmetric(vertical: 16, horizontal: 16) by default', () {
        testWidgets('with support scrolling true', (tester) async {
          final page = await buildPage(tester, asSmallDevice: true);

          expect(page.defaultPadding, equals(expectedPadding));
          final padding = tester.firstWidget<Padding>(find.byKey(BaseState.basePagePaddingKey));
          expect(padding.padding, equals(expectedPadding));
        });
        testWidgets('with support scrolling false', (tester) async {
          final page = await buildPage(tester, asSmallDevice: false);

          expect(page.defaultPadding, equals(expectedPadding));
          final padding = tester.firstWidget<Padding>(find.byKey(BaseState.basePagePaddingKey));
          expect(padding.padding, equals(expectedPadding));
        });
      });

      testWidgets('support Scrolling is by default the ctx.isSmallDevice', (tester) async {
        final page = await buildPage(tester);

        expect(page.supportScrolling(context), equals(context.isSmallDevice));
      });

      testWidgets('should not build the loader and the error overlay in initial state',
          (tester) async {
        final page = await buildPage(tester);

        expect(find.byWidget(page.loader), findsNothing);
        expect(find.byType(ErrorWidget), findsNothing);
      });

      testWidgets('should ever build the Observer, Stack, SafeArea and LayoutBuilder',
          (tester) async {
        await buildPage(tester);

        expect(find.byType(Observer),
            findsNWidgets(2)); // 1 for the loading state, 2 for the error state
        expect(find.byType(Stack), findsNWidgets(2)); // 2 because Scaffold builds one Stack
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsNWidgets(2)); // 2 because Scaffold builds one SafeArea
        expect(find.byType(LayoutBuilder), findsOneWidget);
      });

      testWidgets('autoRun, reaction and when is a empty list by default', (tester) async {
        final page = await buildPage(tester);

        expect(page.autoRun, equals([]));
        expect(page.reaction, equals([]));
        expect(page.when, equals([]));
        expect(page.disposers, equals([]));
      });

      group('when autoRun is empty', () {
        testWidgets('should not call autoRun', (tester) async {
          final page = await buildPage(tester);

          expect(page.autoRun.isEmpty, isTrue);
          expect(page.disposers.isEmpty, isTrue);
        });
      });

      testWidgets('when disposers is empty should not call disposer', (tester) async {
        final page = await buildPage(tester);

        expect(page.disposers.isEmpty, isTrue);
        page.disposeFunc();
        verifyNever(() => reactionDisposer());
      });
    });

    group('Check when I change the value', () {
      testWidgets('scaffold background color should be the same of bgColor param', (tester) async {
        final page = await buildModifiedPage(tester);

        final scaffold = tester.firstWidget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(page.bgColor));
      });

      testWidgets('padding should be the same of defaultPadding param', (tester) async {
        final page = await buildModifiedPage(tester);

        final padding = tester.firstWidget<Padding>(find.byKey(BaseState.basePagePaddingKey));
        expect(padding.padding, equals(page.defaultPadding));
      });

      testWidgets('scaffold appBar should be the same of appBar param', (tester) async {
        await buildModifiedPage(tester);

        final scaffold = tester.firstWidget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.appBar, equals(_appBar));
      });

      testWidgets('should build a SingleChildScrollView if supportScrolling returns true',
          (tester) async {
        _supportScrollView = true;
        await buildModifiedPage(tester);

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('should not build a ScrollView if supportScrolling returns false',
          (tester) async {
        _supportScrollView = false;
        await buildModifiedPage(tester);

        expect(find.byType(SingleChildScrollView), findsNothing);
      });

      testWidgets('should show loading or error when one of states is provided', (tester) async {
        final page = await buildModifiedPage(tester);

        expect(find.byWidget(page.loader), findsNothing);
        expect(find.byKey(BaseState.errorKey), findsNothing);

        page.controller.state.setLoading(true);
        await tester.pump();
        expect(find.byWidget(page.loader), findsOneWidget);
        expect(find.byKey(BaseState.errorKey), findsNothing);

        page.controller.state.setFailure(kServerFailure);
        await tester.pump();
        expect(find.byWidget(page.loader), findsNothing);
        expect(find.byKey(BaseState.errorKey), findsOneWidget);
        expect(page.callsOnClearError, 0);

        await tester.tap(find.byType(TextButton));
        expect(page.callsOnClearError, 1);
      });

      testWidgets('should not rebuild the layout if change the states', (tester) async {
        expect(_buildTimes, equals(0));
        final page = await buildModifiedPage(tester);
        expect(_buildTimes, equals(1));

        page.controller.state.setLoading(true);
        await tester.pump();
        expect(_buildTimes, equals(1));

        page.controller.state.setLoading(true);
        await tester.pump();
        expect(_buildTimes, equals(1));

        page.controller.state.setFailure(kServerFailure);
        await tester.pump();
        expect(_buildTimes, equals(1));

        page.controller.state.setFailure(kServerFailure);
        await tester.pump();
        expect(_buildTimes, equals(1));
      });

      group('when autoRun is notEmpty', () {
        testWidgets('should call autoRun', (tester) async {
          final page = await buildModifiedPage(tester);

          expect(page.autoRun.length, equals(1));
          expect(page.disposers.length, equals(3));

          expect(page.callsAutoRun, equals(1));
          expect(page.controller.isLoading, isFalse);

          page.controller.state.setLoading(true);
          expect(page.callsAutoRun, equals(2));

          page.controller.state.setLoading(true);
          expect(page.callsAutoRun, equals(2));

          page.controller.state.setLoading(false);
          expect(page.callsAutoRun, equals(3));
        });
      });

      group('when reaction is notEmpty', () {
        testWidgets('should call reaction', (tester) async {
          final page = await buildModifiedPage(tester);

          expect(page.reaction.length, equals(1));
          expect(page.disposers.length, equals(3));

          expect(page.callsReaction, equals(0));
          expect(page.controller.isLoading, isFalse);

          page.controller.state.setLoading(true);
          expect(page.callsReaction, equals(1));

          page.controller.state.setLoading(true);
          expect(page.callsReaction, equals(1));

          page.controller.state.setLoading(false);
          expect(page.callsReaction, equals(2));
        });
      });

      group('when "when" attribute have something', () {
        testWidgets('should call when', (tester) async {
          final page = await buildModifiedPage(tester);

          expect(page.when.length, equals(1));
          expect(page.disposers.length, equals(3));

          expect(page.callsWhenRun, equals(1));
          expect(page.controller.isLoading, isFalse);

          page.controller.state.setLoading(true);
          expect(page.controller.isLoading, isTrue);
          expect(page.callsWhenRun, equals(1));
        });
      });

      testWidgets('when disposers is not empty should call disposer', (tester) async {
        final page = await buildModifiedPage(tester);

        expect(page.disposers.isNotEmpty, isTrue);
        page.disposers.clear();
        page.disposers.add(reactionDisposer);
        page.disposeFunc();

        verify(() => reactionDisposer()).called(1);
      });

      testWidgets('when controller is not null should call controller.dispose()', (tester) async {
        final page = await buildModifiedPage(tester);

        expect(page.controller, isNotNull);
        expect(page.controller.disposed, isFalse);
        page.disposeFunc();
        expect(page.controller.disposed, isTrue);
      });
    });
  });
}

class _SampleWidget extends StatelessWidget {
  final BoxConstraints constrains;

  const _SampleWidget({Key? key, required this.constrains}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
