import "package:flutter/material.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/data/services/account_service.dart";
import "package:lechacals_authenticator/utils/vibration_service.dart";

class AccountManager {
  final AccountService _accountService = AccountService();

  Future<List<Account>> loadAccounts() async {
    return await _accountService.loadAccounts();
  }

  Future<void> saveAccounts(List<Account> accounts) async {
    await _accountService.saveAccounts(accounts);
  }

  void addAccount(Account account, List<Account> accounts, VoidCallback onUpdate) {
    // check for duplicates based on secret
    if (!accounts.any((acc) => acc.secret == account.secret)) {
      accounts.add(account);
      VibrationService.successVibration();
      onUpdate();
    }
  }

  void updateAccount(
    Account editedAccount,
    List<Account> accounts,
    VoidCallback onUpdate,
  ) {
    final index = accounts.indexWhere((acc) => acc.id == editedAccount.id);
    if (index != -1) {
      accounts[index] = editedAccount;
      onUpdate();
    }
  }

  void reorderAccounts(int oldIndex, int newIndex, List<Account> accounts) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final account = accounts.removeAt(oldIndex);
    accounts.insert(newIndex, account);
  }
}
