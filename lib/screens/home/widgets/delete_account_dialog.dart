import "package:flutter/material.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/utils/vibration_service.dart";
import "package:lechacals_authenticator/widgets/customs/action_button.dart";

class DeleteAccountDialog {
  DeleteAccountDialog._();

  static Future<bool?> show(BuildContext context, Account account) {
    VibrationService.heavy();

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        // title
        title: const Center(child: Text("Delete Account")),
        titleTextStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),

        // content
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        content: Text.rich(
          style: const TextStyle(fontSize: 18),
          TextSpan(
            children: [
              const TextSpan(text: "The account "),
              TextSpan(
                text: account.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: " will be "),
              const TextSpan(
                text: "deleted",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const TextSpan(text: "."),
            ],
          ),
        ),

        // actions
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              // close
              ActionButton(
                params: ActionButtonParams(
                  onPressed: () {
                    VibrationService.cancelVibration();
                    Navigator.pop(context, false);
                  },
                  icon: Icons.close,
                  color: Colors.green,
                ),
              ),

              // delete
              ActionButton(
                params: ActionButtonParams(
                  onPressed: () {
                    VibrationService.deleteVibration();
                    Navigator.pop(context, true);
                  },
                  icon: Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
