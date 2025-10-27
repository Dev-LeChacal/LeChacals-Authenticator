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

    // progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryColor),

    // use material 3
    useMaterial3: true,
  );
}
