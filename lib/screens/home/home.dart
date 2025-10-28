import "dart:async";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:home_widget/home_widget.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/data/services/otp_service.dart";
import "package:lechacals_authenticator/routes/routes.dart";
import "package:lechacals_authenticator/screens/home/home_constants.dart";
import "package:lechacals_authenticator/screens/home/managers/account_manager.dart";
import "package:lechacals_authenticator/screens/home/managers/time_manager.dart";
import "package:lechacals_authenticator/screens/home/widget_updater.dart";
import "package:lechacals_authenticator/screens/home/widgets/account_reorderable_list.dart";
import "package:lechacals_authenticator/screens/home/widgets/add_options_sheet.dart";
import "package:lechacals_authenticator/screens/home/widgets/empty_state.dart";
import "package:lechacals_authenticator/screens/home/widgets/home_floating_buttons.dart";
import "package:lechacals_authenticator/utils/vibration_service.dart";
import "package:lechacals_authenticator/widgets/account_list_item.dart";
import "package:lechacals_authenticator/widgets/customs/app_bar.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AccountManager _accountManager = AccountManager();
  final TimerManager _timerManager = TimerManager();
  final GlobalKey _globalKey = GlobalKey();

  List<Account> accounts = [];
  bool isEditing = false;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId(appGroupId);
    _loadAccounts();
    _startTimer();
  }

  @override
  void dispose() {
    _timerManager.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timerManager.startTimer((seconds) => setState(() {}), () {
      if (accounts.isNotEmpty) {
        _updateWidgetWithCurrentAccount();
      }
    });
  }

  Future<void> _updateWidgetWithCurrentAccount() async {
    if (accounts.isEmpty || _globalKey.currentContext == null) return;

    final account = accounts.first;
    final code = OTPService.generateTOTP(account.secret);
    final nextCode = OTPService.generateNextTOTP(account.secret);
    final context = _globalKey.currentContext!;

    var path = await HomeWidget.renderFlutterWidget(
      AccountListItem(
        account: account,
        code: code,
        nextCode: nextCode,
        remainingSeconds: _timerManager.remainingSeconds,
        onTap: () {},
      ),
      key: "screenshot",
      logicalSize: context.size!,
      pixelRatio: MediaQuery.of(context).devicePixelRatio,
    );

    setState(() => imagePath = path as String?);
    if (imagePath != null) {
      WidgetUpdater.updateWidget(account, code, imagePath!);
    }
  }

  Future<void> _loadAccounts() async {
    final loadedAccounts = await _accountManager.loadAccounts();
    setState(() => accounts = loadedAccounts);
  }

  Future<void> _saveAccounts() async {
    await _accountManager.saveAccounts(accounts);
  }

  void _addAccount(Account account) {
    _accountManager.addAccount(account, accounts, () => setState(() {}));
    _saveAccounts();
    Navigator.popUntil(context, (route) => route.isFirst);
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
    _accountManager.updateAccount(editedAccount, accounts, () => setState(() {}));
    _saveAccounts();
    isEditing = false;
    Navigator.popUntil(context, (route) => route.isFirst);
    VibrationService.successVibration();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      _accountManager.reorderAccounts(oldIndex, newIndex, accounts);
    });
    _saveAccounts();
  }

  void _toggleEdit() {
    setState(() => isEditing = !isEditing);
    if (!isEditing) _saveAccounts();
    VibrationService.light();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "LeChacal's Authenticator"),
      body: accounts.isEmpty
          ? const EmptyState()
          : AccountReorderableList(
              accounts: accounts,
              remainingSeconds: _timerManager.remainingSeconds,
              isEditing: isEditing,
              globalKey: _globalKey,
              onReorder: _onReorder,
              onEditAccount: _editAccount,
              onCopyCode: _copyCode,
              onDismissed: (direction, index) {
                setState(() {
                  accounts.removeAt(index);
                });
              },
            ),
      floatingActionButton: HomeFloatingButtons(
        isEditing: isEditing,
        onToggleEdit: _toggleEdit,
        onAdd: () => AddOptionsSheet.show(context, _addAccount),
      ),
    );
  }
}
