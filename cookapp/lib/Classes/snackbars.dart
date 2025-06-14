import 'package:cookapp/Settings/settings.dart';
import 'package:flutter/material.dart';

enum SnackBarType {
  error,
  success,
  info,
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
  SnackBarType type = SnackBarType.info,
  bool isBold = false,
}) {
  Color textColor;
  switch (type) {
    case SnackBarType.error:
      textColor = Colors.red;
      break;
    case SnackBarType.success:
      textColor = Colors.green;
      break;
    case SnackBarType.info:
    default:
      textColor = Colors.blue;
      break;
  }

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: snackbarShape(),
      margin: const EdgeInsets.all(16.0),
      backgroundColor: themeNotifier.value == ThemeMode.dark ? Colors.black : Colors.white,
    ),
  );
}

ShapeBorder snackbarShape({
  double borderRadius = 25.0,
}) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  );
}
