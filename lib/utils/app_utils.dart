import 'package:flutter/material.dart';

class AppUtils {
  static showOneTimeSnackBar(
      {required BuildContext context,
      required String message,
      Color bg = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bg,
        content: Text(message),
      ),
    );
  }
}
