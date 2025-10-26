import "dart:async";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/data/services/account_service.dart";
import "package:lechacals_authenticator/data/services/otp_service.dart";
import "package:lechacals_authenticator/screens/manual_entry.dart";
import "package:lechacals_authenticator/screens/qr_scanner_screen.dart";
import "package:lechacals_authenticator/widgets/account_list_item.dart";
import "package:lechacals_authenticator/widgets/customs/action_button.dart";
import "package:lechacals_authenticator/widgets/customs/app_bar.dart";
import "package:lechacals_authenticator/widgets/customs/modal_bottom_sheet.dart";
import "package:vibration/vibration.dart";

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
    CustomModalBottomSheet.show(
      context: context,
      children: [
        // manual entry button
        ActionButton(
          params: ActionButtonParams(
            onPressed: () {
              Navigator.pop(context);
              _showManualEntryDialog();
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScannerScreen(onAdd: _addAccount),
                ),
              );
            },
            icon: Icons.qr_code_scanner,
            label: "Scan QR Code",
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  void _showManualEntryDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManualEntryScreen(onAdd: _addAccount)),
    );
  }

  void _addAccount(Account account) {
    // add account
    setState(() {
      // check for duplicates based on secret
      if (!accounts.any((acc) => acc.secret == account.secret)) {
        accounts.add(account);
      }
    });

    // save
    _saveAccounts();

    // return to home screen
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _deleteAccountDialog(Account account) {
    _deleteDialogVibration();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // padding
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

        // title
        title: const Center(child: Text("Delete Account")),
        titleTextStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),

        // content
        content: Text.rich(
          // style
          style: const TextStyle(fontSize: 16),

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
            children: [
              // cancel button
              ActionButton(
                params: ActionButtonParams(
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.close,
                  color: Colors.green,
                  size: 50,
                ),
              ),

              // spacing
              const SizedBox(width: 16),

              // delete button
              ActionButton(
                params: ActionButtonParams(
                  onPressed: () {
                    setState(() {
                      accounts.removeWhere((acc) => acc.id == account.id);
                    });
                    _saveAccounts();
                    Navigator.pop(context);
                  },
                  icon: Icons.delete,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    _copyVibration();
  }

  void _copyVibration() => Vibration.vibrate(duration: 50, amplitude: 10);
  void _reorderVibration() => Vibration.vibrate(duration: 100, amplitude: 50);
  void _deleteDialogVibration() => Vibration.vibrate(duration: 100, amplitude: 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "LeChacal's Authenticator"),
      body: accounts.isEmpty ? _buildEmptyState() : _buildListView(),

      // floating action button
      floatingActionButton: ActionButton(
        params: ActionButtonParams(
          onPressed: _showAddOptions,
          icon: Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ReorderableListView.builder(
      // padding
      padding: const EdgeInsets.symmetric(vertical: 8),

      // haptic feedback
      onReorderStart: (index) => _reorderVibration(),
      onReorderEnd: (index) => _reorderVibration(),

      // on reorder
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final account = accounts.removeAt(oldIndex);
          accounts.insert(newIndex, account);
        });
        _saveAccounts();
      },

      // items
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        return AccountListItem(
          key: ValueKey(account.id),
          account: account,
          code: OTPService.generateTOTP(account.secret),
          remainingSeconds: remainingSeconds,
          onTap: () => _copyCode(OTPService.generateTOTP(account.secret)),
          onDoubleTap: () => _deleteAccountDialog(account),
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
