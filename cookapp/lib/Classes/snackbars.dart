import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 2),
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: snackbarShape(),
      margin: const EdgeInsets.all(16.0),
    ),
  );
}

ShapeBorder snackbarShape({
  double borderRadius = 10.0,
}) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  );
}
