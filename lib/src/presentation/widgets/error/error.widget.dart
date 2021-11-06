import 'package:flutter/material.dart';
import 'package:foo/src/core/failures.dart';
import 'package:foo/src/localization/app_localizations.dart';

class ErrorWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback clearErrorState;

  const ErrorWidget({
    Key? key,
    required this.failure,
    required this.clearErrorState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: clearErrorState,
          child: Opacity(
            opacity: .6,
            child: Container(
              color: Colors.black,
            ),
          ),
        ),
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(
            failure.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(failure.message),
          actions: [
            TextButton(
              onPressed: clearErrorState,
              child: Text(
                AppLocalizations.of(context)!.ok,
              ),
            ),
          ],
        )
      ],
    );
  }
}
