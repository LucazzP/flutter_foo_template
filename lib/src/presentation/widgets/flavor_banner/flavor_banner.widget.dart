import 'package:flutter/material.dart';
import 'package:foo/src/core/flavor/flavor_config.model.dart';

class FlavorBannerWidget extends StatelessWidget {
  final Widget child;

  const FlavorBannerWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.isProduction) return child;
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
          message: FlavorConfig.name.toUpperCase(),
          textDirection: Directionality.of(context),
          layoutDirection: Directionality.of(context),
          location: BannerLocation.topStart,
          color: FlavorConfig.color,
        ),
      ),
    );
  }
}
