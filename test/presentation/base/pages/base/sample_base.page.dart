part of 'base.page_test.dart';

class _SampleBasePage extends StatefulWidget {
  final ControllerTest controller;
  const _SampleBasePage({super.key, required this.controller});

  @override
  _SampleBasePageState createState() => _SampleBasePageState();
}

class _SampleBasePageState extends ScaffoldBaseState<_SampleBasePage, ControllerTest> {
  @override
  PreferredSizeWidget appBar(BuildContext ctx) => _appBar;

  @override
  ControllerTest createController() => widget.controller;

  @override
  Widget child(BuildContext context, BoxConstraints constraints) {
    _buildTimes++;
    return _SampleWidget(key: _sampleWidgetKey, constrains: constraints);
  }
}
