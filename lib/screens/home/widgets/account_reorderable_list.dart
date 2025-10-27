import "package:flutter/material.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/data/services/otp_service.dart";
import "package:lechacals_authenticator/screens/home/widgets/delete_account_dialog.dart";
import "package:lechacals_authenticator/utils/vibration_service.dart";
import "package:lechacals_authenticator/widgets/account_list_item.dart";

class AccountReorderableList extends StatelessWidget {
  final List<Account> accounts;
  final int remainingSeconds;
  final bool isEditing;
  final GlobalKey globalKey;
  final Function(int, int) onReorder;
  final Function(Account) onEditAccount;
  final Function(String) onCopyCode;

  const AccountReorderableList({
    super.key,
    required this.accounts,
    required this.remainingSeconds,
    required this.isEditing,
    required this.globalKey,
    required this.onReorder,
    required this.onEditAccount,
    required this.onCopyCode,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      // padding
      padding: const EdgeInsets.symmetric(vertical: 8),

      // onReorder methods
      onReorderStart: (index) => VibrationService.medium(),
      onReorderEnd: (index) => VibrationService.medium(),
      onReorder: onReorder,

      // items
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        final code = OTPService.generateTOTP(account.secret);

        return Dismissible(
          // key
          key: index == 0 ? globalKey : ValueKey(account.id),

          // direction
          direction: isEditing ? DismissDirection.startToEnd : DismissDirection.none,
          confirmDismiss: (direction) async {
            return await DeleteAccountDialog.show(context, account);
          },

          // background
          background: _buildDismissBackground(),

          // child
          child: AccountListItem(
            key: ValueKey(account.id),
            account: account,
            code: code,
            remainingSeconds: remainingSeconds,
            onTap: () => isEditing ? onEditAccount(account) : onCopyCode(code),
          ),
        );
      },
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      // alignment
      alignment: Alignment.centerLeft,

      // decoration
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),

      // padding and margin
      padding: const EdgeInsets.only(left: 20),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),

      // child
      child: const Icon(Icons.delete, color: Colors.white, size: 26),
    );
  }
}
