import "dart:convert";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:lechacals_authenticator/data/models/account.dart";

class AccountService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
  );

  static const String _accountsKey = "accounts";

  Future<List<Account>> loadAccounts() async {
    try {
      final data = await _storage.read(key: _accountsKey);
      if (data != null) {
        final List<dynamic> jsonList = json.decode(data);
        return jsonList.map((json) => Account.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> saveAccounts(List<Account> accounts) async {
    final jsonList = accounts.map((acc) => acc.toJson()).toList();
    await _storage.write(key: _accountsKey, value: json.encode(jsonList));
  }

  Future<void> deleteAccount(String accountId, List<Account> accounts) async {
    accounts.removeWhere((acc) => acc.id == accountId);
    await saveAccounts(accounts);
  }

  Future<void> addAccount(Account account, List<Account> accounts) async {
    accounts.add(account);
    await saveAccounts(accounts);
  }
}
