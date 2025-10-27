import "package:flutter/material.dart";
import "package:lechacals_authenticator/widgets/customs/action_button.dart";

class HomeFloatingButtons extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onToggleEdit;
  final VoidCallback onAdd;

  const HomeFloatingButtons({
    super.key,
    required this.isEditing,
    required this.onToggleEdit,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 10,
      children: [
        // edit button
        ActionButton(
          params: ActionButtonParams(
            onPressed: onToggleEdit,
            icon: isEditing ? Icons.check : Icons.edit,
            color: isEditing ? Colors.green : Colors.blue,
          ),
        ),
        
        // add button
        ActionButton(
          params: ActionButtonParams(
            onPressed: isEditing ? () {} : onAdd,
            icon: isEditing ? Icons.block : Icons.add,
            color: isEditing ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}
