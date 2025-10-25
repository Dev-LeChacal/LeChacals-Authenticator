import "package:flutter/material.dart";

class ColorUtils {
  static Color getColorForName(String name) {
    final hash = name.hashCode;
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[hash.abs() % colors.length];
  }
}
