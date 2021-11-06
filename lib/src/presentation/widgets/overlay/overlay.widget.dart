import 'package:flutter/material.dart';

class OverlayWidget extends StatelessWidget {
  final Widget child;
  
  const OverlayWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Opacity(
        opacity: .6,
        child: Container(
          color: Colors.black,
          child: Center(
            child: child,
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
