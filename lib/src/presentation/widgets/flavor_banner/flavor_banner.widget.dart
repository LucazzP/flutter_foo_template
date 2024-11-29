import 'package:flutter/material.dart';
import 'package:foo/src/core/flavor/build_config.model.dart';

class FlavorBannerWidget extends StatelessWidget {
  final Widget child;

  const FlavorBannerWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (BuildConfig.isProduction) return child;
    return Stack(
      children: <Widget>[
        child,
        _buildBanner(context),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: BannerPainter(
          message: BuildConfig.name.toUpperCase(),
          textDirection: Directionality.of(context),
          layoutDirection: Directionality.of(context),
          location: BannerLocation.topStart,
          color: BuildConfig.color,
        ),
      ),
    );
  }
}
