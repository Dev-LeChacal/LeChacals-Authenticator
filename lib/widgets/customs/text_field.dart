import "package:flutter/material.dart";

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Color color;
  final TextCapitalization capitalization;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.color = Colors.white,
    this.capitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        // deuxieme container sinon ca bug avec le TextField
        decoration: BoxDecoration(
          color: color.withAlpha(33),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(150)),
        ),

        // text field
        child: TextField(
          // controller
          controller: controller,

          // decoration
          decoration: InputDecoration(
            // null borders
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,

            // padding
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

            // hint
            hintText: hint,
            hintStyle: TextStyle(color: color.withAlpha(200)),
          ),

          // style
          style: TextStyle(color: color),

          // capitalization and keyboard type
          textCapitalization: capitalization,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}
