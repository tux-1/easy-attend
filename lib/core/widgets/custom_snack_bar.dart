import 'package:easyattend/core/themes/styles.dart';
import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    final Color backgroundColor;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = Color.fromARGB(255, 73, 156, 76);
        break;
      case SnackBarType.error:
        backgroundColor = const Color.fromARGB(255, 196, 46, 36);
        break;
      case SnackBarType.info:
        backgroundColor = const Color.fromARGB(255, 29, 100, 158);
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Styles.medium14.copyWith(
            color: type != SnackBarType.error ? Colors.white : null,
          ),
        ),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
        duration: duration,
      ),
    );
  }
}
