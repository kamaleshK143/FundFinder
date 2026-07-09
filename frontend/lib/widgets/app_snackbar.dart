import 'package:flutter/material.dart';

enum SnackBarType { error, success, info }

/// Consistent, theme-colored snackbars, replacing the ad hoc
/// ScaffoldMessenger.showSnackBar(SnackBar(...)) calls scattered across
/// screens (each with its own hardcoded color).
class AppSnackBar {
  AppSnackBar._();

  static void show(BuildContext context, String message, {SnackBarType type = SnackBarType.info}) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color background;
    final IconData icon;
    switch (type) {
      case SnackBarType.error:
        background = colorScheme.error;
        icon = Icons.error_outline;
        break;
      case SnackBarType.success:
        background = Colors.green.shade700;
        icon = Icons.check_circle_outline;
        break;
      case SnackBarType.info:
        background = colorScheme.primary;
        icon = Icons.info_outline;
        break;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: background,
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
            ],
          ),
        ),
      );
  }
}
