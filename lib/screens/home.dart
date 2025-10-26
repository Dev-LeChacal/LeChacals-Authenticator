import "dart:async";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/data/services/account_service.dart";
import "package:lechacals_authenticator/data/services/otp_service.dart";
import "package:lechacals_authenticator/routes/routes.dart";
import "package:lechacals_authenticator/utils/vibration_service.dart";
import "package:lechacals_authenticator/widgets/account_list_item.dart";
import "package:lechacals_authenticator/widgets/customs/action_button.dart";
import "package:lechacals_authenticator/widgets/customs/app_bar.dart";
import "package:lechacals_authenticator/widgets/customs/modal_bottom_sheet.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AccountService _accountService = AccountService();
  List<Account> accounts = [];
  int remainingSeconds = 30;
  Timer? timer;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    remainingSeconds = OTPService.getRemainingSeconds();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingSeconds = OTPService.getRemainingSeconds();
      });
    });
  }

  Future<void> _loadAccounts() async {
    final loadedAccounts = await _accountService.loadAccounts();
    setState(() {
      accounts = loadedAccounts;
    });
  }

  Future<void> _saveAccounts() async {
    await _accountService.saveAccounts(accounts);
  }

  void _showAddOptions() {
    VibrationService.light();

    CustomModalBottomSheet.show(
      context: context,
      children: [
        // manual entry button
        ActionButton(
          params: ActionButtonParams(
            onPressed: () {
              VibrationService.light();
              Navigator.pushNamed(context, Routes.manualEntry, arguments: _addAccount);
            },
            icon: Icons.keyboard,
            label: "Manual Entry",
            color: Colors.blue,
          ),
        ),

        // scan QR code button
        ActionButton(
          params: ActionButtonParams(
            onPressed: () {
              VibrationService.light();
              Navigator.pushNamed(context, Routes.qrScanner, arguments: _addAccount);
            },
            icon: Icons.qr_code_scanner,
            label: "Scan QR Code",
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  void _addAccount(Account account) {
    // add account
    setState(() {
      // check for duplicates based on secret
      if (!accounts.any((acc) => acc.secret == account.secret)) {
        // add
        accounts.add(account);

        // success vibration
        VibrationService.successVibration();
      }
    });

    // save
    _saveAccounts();

    // return to home screen
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<bool?> _deleteAccountDialog(Account account) async {
    VibrationService.heavy();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // title
        title: const Center(child: Text("Delete Account")),
        titleTextStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),

        // content
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        content: Text.rich(
          // style
          style: const TextStyle(fontSize: 18),

          // spans
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

            // children
            children: [
              // cancel button
              ActionButton(
                params: ActionButtonParams(
                  // onPressed
                  onPressed: () {
                    VibrationService.cancelVibration();
                    Navigator.pop(context, false);
                  },

                  // icon, color, size
                  icon: Icons.close,
                  color: Colors.green,
                ),
              ),

              // delete button
              ActionButton(
                params: ActionButtonParams(
                  onPressed: () {
                    VibrationService.deleteVibration();

                    // delete account
                    setState(() {
                      accounts.removeWhere((acc) => acc.id == account.id);
                    });

                    // save
                    _saveAccounts();

                    // close dialog
                    Navigator.pop(context, true);
                  },

                  // icon, color, size
                  icon: Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return null;
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    VibrationService.light();
  }

  void _editAccount(Account account) {
    VibrationService.light();

    Navigator.pushNamed(
      context,
      Routes.editAccount,
      arguments: {"account": account, "onEndEdit": _onEndEdit},
    );
  }

  void _onEndEdit(Account editedAccount) {
    // update account
    setState(() {
      final index = accounts.indexWhere((acc) => acc.id == editedAccount.id);
      if (index != -1) {
        accounts[index] = editedAccount;
      }
    });

    // save
    _saveAccounts();

    // finish editing
    isEditing = false;

    // return to home screen
    Navigator.popUntil(context, (route) => route.isFirst);

    VibrationService.successVibration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "LeChacal's Authenticator"),
      body: accounts.isEmpty ? _buildEmptyState() : _buildListView(),

      // floating action buttons
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 10,

        // buttons
        children: [
          // edit button
          ActionButton(
            params: ActionButtonParams(
              onPressed: () {
                // toggle edit mode
                setState(() {
                  isEditing = !isEditing;
                });

                // save if exiting edit mode
                if (!isEditing) {
                  _saveAccounts();
                }

                VibrationService.light();
              },

              // icon and color
              icon: isEditing ? Icons.check : Icons.edit,
              color: isEditing ? Colors.green : Colors.blue,
            ),
          ),

          // add button
          ActionButton(
            params: ActionButtonParams(
              // block adding in edit mode
              onPressed: isEditing ? () {} : _showAddOptions,

              // icon and color
              icon: isEditing ? Icons.block : Icons.add,
              color: isEditing ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ReorderableListView.builder(
      // padding
      padding: const EdgeInsets.symmetric(vertical: 8),

      // haptic feedback
      onReorderStart: (index) => VibrationService.medium(),
      onReorderEnd: (index) => VibrationService.medium(),

      // on reorder
      onReorder: (oldIndex, newIndex) {
        // update list
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final account = accounts.removeAt(oldIndex);
          accounts.insert(newIndex, account);
        });

        // save
        _saveAccounts();
      },

      // items
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        final code = OTPService.generateTOTP(account.secret);

        return Dismissible(
          key: ValueKey(account.id),
          direction: isEditing ? DismissDirection.startToEnd : DismissDirection.none,
          dismissThresholds: const {DismissDirection.endToStart: 0.3},

          // confirm dismiss
          confirmDismiss: (direction) async {
            return await _deleteAccountDialog(account);
          },

          // background
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.delete, color: Colors.white, size: 26),
          ),

          // item
          child: AccountListItem(
            key: ValueKey(account.id),
            account: account,
            code: code,
            remainingSeconds: remainingSeconds,
            onTap: () => isEditing ? _editAccount(account) : _copyCode(code),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
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

          // subtext
          Text(
            "Tap the + button to add your first account",
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
