import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/routes/routes.dart";
import "package:lechacals_authenticator/screens/edit_account.dart";
import "package:lechacals_authenticator/screens/home.dart";
import "package:lechacals_authenticator/screens/manual_entry.dart";
import "package:lechacals_authenticator/screens/qr_scanner_screen.dart";
import "package:lechacals_authenticator/themes/app_colors.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const AuthenticatorApp());
}

class AuthenticatorApp extends StatelessWidget {
  const AuthenticatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LeChacal's Authenticator",
      debugShowCheckedModeBanner: false,
      theme: AppColors.theme,
      routes: {
        Routes.home: (context) => const HomeScreen(),

        Routes.manualEntry: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Function(Account);
          return ManualEntryScreen(onAdd: args);
        },

        Routes.qrScanner: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Function(Account);
          return QRScannerScreen(onAdd: args);
        },

        Routes.editAccount: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

          final account = args["account"] as Account;
          final onEndEdit = args["onEndEdit"] as void Function(Account);

          return EditAccountScreen(account: account, onEndEdit: onEndEdit);
        },
      },
    );
  }
}
