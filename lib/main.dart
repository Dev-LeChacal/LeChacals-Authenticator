import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lechacals_authenticator/screens/home.dart";
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
      home: const HomeScreen(),
    );
  }
}
