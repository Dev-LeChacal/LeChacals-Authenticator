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
    cardTheme: const CardThemeData(
      color: Color.from(alpha: 0.25, red: 0.2431, green: 0.2745, blue: 0.3686),
    ),

    // progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryColor),

    // use material 3
    useMaterial3: true,
  );
}
