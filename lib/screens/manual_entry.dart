import "package:flutter/material.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/widgets/customs/action_button.dart";
import "package:lechacals_authenticator/widgets/customs/app_bar.dart";
import "package:lechacals_authenticator/widgets/customs/button.dart";
import "package:lechacals_authenticator/widgets/customs/scaffold_messenger.dart";
import "package:lechacals_authenticator/widgets/customs/text_field.dart";

class ManualEntryScreen extends StatefulWidget {
  final Function(Account) onAdd;

  const ManualEntryScreen({super.key, required this.onAdd});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final nameController = TextEditingController();
  final secretController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    secretController.dispose();
    super.dispose();
  }

  void addAccount() {
    if (nameController.text.isEmpty || secretController.text.isEmpty) {
      CustomScaffoldMessenger.error(context, message: "The fields cannot be empty.");
      return;
    }

    final account = Account(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      secret: secretController.text.replaceAll(" ", "").toUpperCase(),
    );

    widget.onAdd(account);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Manual Entry",
        leftAction: ActionButtonParams(
          onPressed: () => Navigator.pop(context),
          icon: Icons.arrow_back,
          color: Colors.white,
          size: 50,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        // children
        children: [
          // name
          CustomTextField(
            controller: nameController,
            hint: "Enter the account name",
            keyboardType: TextInputType.emailAddress,
          ),

          // spacing
          const SizedBox(height: 16),

          // secret
          CustomTextField(
            controller: secretController,
            hint: "Enter the secret key",
            capitalization: TextCapitalization.characters,
          ),

          // spacing
          const SizedBox(height: 64),
        ],
      ),

      // floating button
      floatingActionButton: CustomButton(
        onTap: addAccount,
        text: "Add Account",
        color: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
