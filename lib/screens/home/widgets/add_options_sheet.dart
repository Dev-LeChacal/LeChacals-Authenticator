import "package:flutter/material.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/routes/routes.dart";
import "package:lechacals_authenticator/utils/vibration_service.dart";
import "package:lechacals_authenticator/widgets/customs/action_button.dart";
import "package:lechacals_authenticator/widgets/customs/modal_bottom_sheet.dart";

class AddOptionsSheet {
  AddOptionsSheet._();

  static void show(BuildContext context, void Function(Account) onAddAccount) {
    CustomModalBottomSheet.show(
      context: context,
      children: [
        // manual entry
        ActionButton(
          params: ActionButtonParams(
            onPressed: () {
              VibrationService.light();
              Navigator.pushNamed(context, Routes.manualEntry, arguments: onAddAccount);
            },

            // icon, label, color
            icon: Icons.keyboard,
            label: "Manual Entry",
            color: Colors.cyan,
          ),
        ),

        // qr code scanner
        ActionButton(
          params: ActionButtonParams(
            onPressed: () {
              VibrationService.light();
              Navigator.pushNamed(context, Routes.qrScanner, arguments: onAddAccount);
            },

            // icon, label, color
            icon: Icons.qr_code_scanner,
            label: "Scan QR Code",
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
