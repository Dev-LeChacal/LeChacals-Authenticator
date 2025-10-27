import "package:flutter/material.dart";

class AppColors {
  AppColors._();

  static const Color primaryColor = Color.fromARGB(255, 71, 197, 255);

  static final ThemeData theme = ThemeData(
    // color scheme
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: primaryColor,
    ),

    // card theme
    cardTheme: const CardThemeData(color: Color.fromARGB(255, 28, 32, 44)),

    // progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryColor),

    // use material 3
    useMaterial3: true,
  );
}
