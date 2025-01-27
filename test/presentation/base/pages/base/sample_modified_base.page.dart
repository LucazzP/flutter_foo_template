part of 'base.page_test.dart';

class _SampleModifiedBasePage extends StatefulWidget {
  final ControllerTest controller;
  const _SampleModifiedBasePage({super.key, required this.controller});

  @override
  _SampleModifiedBasePageState createState() => _SampleModifiedBasePageState();
}

class _SampleModifiedBasePageState
    extends ScaffoldBaseState<_SampleModifiedBasePage, ControllerTest> {
  @override
  ControllerTest createController() => widget.controller;

  int callsAutoRun = 0;
  int callsReaction = 0;
  int callsWhenRun = 0;
  int callsOnClearError = 0;

  @override
  final Color bgColor = const Color(0x12345678);

  @override
  final defaultPadding = const EdgeInsets.all(30);

  @override
  PreferredSizeWidget appBar(BuildContext ctx) => _appBar;

  @override
  bool supportScrolling(BuildContext ctx) => _supportScrollView;

  @override
  get autoRun => [
        () {
          callsAutoRun++;
          controller.isLoading;
        }
      ];

  @override
  get reaction => [
        react.Reaction(
          () => controller.isLoading,
          (isLoading) {
            callsReaction++;
          },
        )
      ];

  @override
  get when => [
        (
          (_) {
            controller.isLoading;
            return true;
          },
          () {
            callsWhenRun++;
            controller.isLoading;
          }
        )
      ];

  @override
  Widget child(BuildContext ctx, BoxConstraints cts) {
    _buildTimes++;
    return _SampleWidget(key: _sampleWidgetKey, constrains: cts);
  }

  @override
  void onClearError() {
    callsOnClearError++;
  }
}
