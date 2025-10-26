import "package:flutter/material.dart";

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color color;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 50;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: buttonHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color.withAlpha(50),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(100)),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
      ),
    );
  }
}
