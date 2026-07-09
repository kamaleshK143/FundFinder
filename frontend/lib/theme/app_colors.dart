import 'package:flutter/material.dart';

/// Brand seed colors for [AppTheme]'s Material 3 ColorScheme. Everything else
/// (surfaces, containers, tonal variants, dark-mode counterparts) is derived
/// from these two seeds by ColorScheme.fromSeed - screens should read colors
/// from Theme.of(context).colorScheme rather than these constants directly.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0B5FBF);
  static const Color accent = Color(0xFFF59E0B);
}
