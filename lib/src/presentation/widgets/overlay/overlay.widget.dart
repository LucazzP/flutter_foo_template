import 'package:flutter/material.dart';

class OverlayWidget extends StatelessWidget {
  final Widget child;
  
  const OverlayWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Opacity(
        opacity: .6,
        child: Container(
          color: Colors.black,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
