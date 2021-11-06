part of 'base.page_test.dart';

class _SampleBasePage extends StatefulWidget {
  const _SampleBasePage({Key? key}) : super(key: key);

  @override
  _SampleBasePageState createState() => _SampleBasePageState();
}

class _SampleBasePageState extends BaseState<_SampleBasePage, ControllerTest> {
  @override
  PreferredSizeWidget appBar(BuildContext ctx) => _appBar;

  @override
  Widget child(BuildContext context, BoxConstraints constraints) {
    _buildTimes++;
    return _SampleWidget(key: _sampleWidgetKey, constrains: constraints);
  }
}

class SampleBaseModule extends Module {
  @override
  List<Bind<Object>> get binds => [
    Bind.factory((i) => ControllerTest()),
  ];
}
