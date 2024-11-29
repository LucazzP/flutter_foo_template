import 'package:flutter/cupertino.dart';

extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsets addTo({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      copyWith(
          left: this.left + left,
          top: this.top + top,
          right: this.right + right,
          bottom: this.bottom + bottom);
}
