import "package:flutter/material.dart";

class CustomModalBottomSheet {
  CustomModalBottomSheet._();

  static void show({required BuildContext context, required List<Widget> children}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: children,
            ),
          ),
        );
      },
    );
  }
}
