import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:foo/src/presentation/extensions/context.ext.dart';
import 'package:foo/src/presentation/base/controller/base.store.dart';
import 'package:foo/src/presentation/base/pages/base.page.dart';
import 'package:foo/src/presentation/styles/app_color_scheme.dart';
import 'package:foo/src/presentation/widgets/error/error.widget.dart';
import 'package:foo/src/presentation/widgets/overlay/overlay.widget.dart';

abstract class ScaffoldBaseState<T extends StatefulWidget, S extends BaseStore>
    extends BaseState<T, S> {
  static const errorKey = Key('ErrorWidgetKey');
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Color get bgColor => AppColorScheme.colorScheme.surface;
  bool get shouldRemoveAppbarHeight => false;
  bool get showLoadingOverlay => true;
  bool get showErrorOverlay => true;
  EdgeInsets get defaultPadding => const EdgeInsets.symmetric(vertical: 16, horizontal: 16);

  Widget child(BuildContext context, BoxConstraints constraints);

  @visibleForTesting
  void onClearError() {}

  @visibleForTesting
  static const basePagePaddingKey = Key('basePagePadding');

  PreferredSizeWidget appBar(BuildContext ctx);

  PreferredSizeWidget _buildAppBar(BuildContext ctx) {
    final _appBar = appBar(ctx);
    return _appBar;
  }

  bool get hasAppBar => scaffoldKey.currentState?.hasAppBar ?? false;
  bool supportScrolling(BuildContext context) => context.isSmallDevice;
  Widget loader = const Center(child: CircularProgressIndicator());

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    final _appBar = _buildAppBar(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Scaffold(
          backgroundColor: bgColor,
          appBar: _appBar,
          key: scaffoldKey,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (_, BoxConstraints constrains) {
                final layoutWithPadding = Padding(
                  key: basePagePaddingKey,
                  padding: defaultPadding,
                  child: child(context, constrains),
                );

                return supportScrolling(context)
                    ? SingleChildScrollView(child: layoutWithPadding)
                    : layoutWithPadding;
              },
            ),
          ),
        ),
        if (showLoadingOverlay)
          Observer(builder: (_) {
            return (controller.isLoading && !controller.hasFailure)
                ? OverlayWidget(child: loader)
                : const SizedBox.shrink();
          }),
        if (showErrorOverlay)
          Observer(builder: (_) {
            return controller.hasFailure
                ? ErrorWidget(
                    key: errorKey,
                    failure: controller.failure!,
                    clearErrorState: () {
                      controller.clearErrors();
                      onClearError();
                    },
                  )
                : const SizedBox.shrink();
          })
      ],
    );
  }
}
