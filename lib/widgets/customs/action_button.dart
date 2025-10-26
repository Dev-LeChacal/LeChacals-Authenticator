import "package:flutter/material.dart";

class ActionButton extends StatelessWidget {
  final ActionButtonParams params;

  const ActionButton({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: params.onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: params.size,
            height: params.size,
            decoration: BoxDecoration(
              color: params.color.withAlpha(50),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: params.color.withAlpha(100)),
            ),
            child: Icon(
              params.icon,
              color: params.color.withAlpha(150),
              size: params.size / 2,
            ),
          ),
          if (params.label.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              params.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ActionButtonParams {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;
  final String label;
  final double size;

  ActionButtonParams({
    required this.onPressed,
    required this.icon,
    this.color = Colors.grey,
    this.label = "",
    this.size = 56,
  });
}
