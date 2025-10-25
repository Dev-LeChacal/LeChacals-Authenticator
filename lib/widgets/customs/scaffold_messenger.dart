import "package:flutter/material.dart";
import "package:lechacals_authenticator/widgets/customs/action_button.dart";

enum SnackBarType { success, error, warning, info }

class CustomScaffoldMessenger {
  CustomScaffoldMessenger._();

  static void _show(
    BuildContext context,
    SnackBarType type, {
    required String message,
    Duration? duration,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    final config = _getSnackBarConfig(type);
    final defaultDuration = type == SnackBarType.error
        ? const Duration(seconds: 4)
        : const Duration(seconds: 3);

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            // icon
            Icon(config.icon, color: Colors.white, size: 20),

            // spacing
            const SizedBox(width: 12),

            // message
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(width: 8),

            ActionButton(
              params: ActionButtonParams(
                onPressed: () => messenger.hideCurrentSnackBar(),
                icon: Icons.close,
                color: Colors.white,
                size: 48,
              ),
            ),
          ],
        ),

        // padding
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        // duration
        duration: duration ?? defaultDuration,

        // style
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: config.color,
        elevation: 8,
      ),
    );
  }

  static _SnackBarConfig _getSnackBarConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(icon: Icons.check, color: const Color(0xFF4CAF50));
      case SnackBarType.error:
        return _SnackBarConfig(icon: Icons.error, color: const Color(0xFFF44336));
      case SnackBarType.warning:
        return _SnackBarConfig(icon: Icons.warning, color: const Color(0xFFFF9800));
      case SnackBarType.info:
        return _SnackBarConfig(icon: Icons.info, color: const Color(0xFF2196F3));
    }
  }

  static void success(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(context, SnackBarType.success, message: message, duration: duration);
  }

  static void error(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(context, SnackBarType.error, message: message, duration: duration);
  }

  static void warning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(context, SnackBarType.warning, message: message, duration: duration);
  }

  static void info(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(context, SnackBarType.info, message: message, duration: duration);
  }
}

class _SnackBarConfig {
  final IconData icon;
  final Color color;

  _SnackBarConfig({required this.icon, required this.color});
}
