import "package:flutter/material.dart";

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // icon
          Icon(Icons.vpn_key_outlined, size: 100, color: Colors.grey[300]),

          // spacing
          const SizedBox(height: 24),

          // text
          Text(
            "No accounts yet",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),

          // spacing
          const SizedBox(height: 8),

          // text
          Text(
            "Tap the + button to add your first account",
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
