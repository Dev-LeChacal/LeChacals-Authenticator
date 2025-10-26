import "package:flutter/material.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/widgets/customs/action_button.dart";
import "package:lechacals_authenticator/widgets/customs/app_bar.dart";
import "package:lechacals_authenticator/widgets/customs/button.dart";
import "package:lechacals_authenticator/widgets/customs/scaffold_messenger.dart";
import "package:lechacals_authenticator/widgets/customs/text_field.dart";

class EditAccountScreen extends StatefulWidget {
  final Account account;
  final void Function(Account) onEndEdit;

  const EditAccountScreen({super.key, required this.account, required this.onEndEdit});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final nameController = TextEditingController();
  final secretController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.account.name;
    secretController.text = widget.account.secret;
  }

  @override
  void dispose() {
    nameController.dispose();
    secretController.dispose();
    super.dispose();
  }

  void editAcount() {
    if (nameController.text.isEmpty || secretController.text.isEmpty) {
      CustomScaffoldMessenger.error(context, message: "The fields cannot be empty.");
      return;
    }

    final account = widget.account.copyWith(
      name: nameController.text,
      secret: secretController.text,
    );

    widget.onEndEdit(account);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit Account",
        leftAction: ActionButtonParams(
          onPressed: () => Navigator.pop(context),
          icon: Icons.arrow_back,
          color: Colors.white,
          size: 50,
        ),
      ),
      body: Column(
        // children
        children: [
          // spacing
          const SizedBox(height: 32),

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
        ],
      ),

      // floating button
      floatingActionButton: CustomButton(
        onTap: editAcount,
        text: "Edit Account",
        color: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
