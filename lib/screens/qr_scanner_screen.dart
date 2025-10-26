// ignore_for_file: unused_local_variable

import "package:flutter/material.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/widgets/customs/action_button.dart";
import "package:lechacals_authenticator/widgets/customs/app_bar.dart";
import "package:mobile_scanner/mobile_scanner.dart";

class QRScannerScreen extends StatelessWidget {
  final void Function(Account) onAdd;

  const QRScannerScreen({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const scanAreaSize = 200.0;

    final scanWindow = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: "Scan QR Code",
        leftAction: ActionButtonParams(
          onPressed: () => Navigator.pop(context),
          icon: Icons.arrow_back,
          color: Colors.white,
          size: 50,
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleQRCodeDetection,
            tapToFocus: true,
            scanWindow: scanWindow,
          ),
          _buildScannerOverlay(scanAreaSize),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay(double size) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _handleQRCodeDetection(BarcodeCapture capture) {
    final Barcode barcode = capture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code != null && code.startsWith("otpauth://")) {
      final uri = Uri.parse(code);

      final label = uri.path.substring(1);

      final labelParts = Uri.decodeComponent(label).split(":");
      final accountName = labelParts.length > 1 ? labelParts[1] : labelParts[0];

      final secret = uri.queryParameters["secret"];
      final issuer = uri.queryParameters["issuer"];
      final algorithm = uri.queryParameters["algorithm"] ?? "SHA1";
      final digits = int.tryParse(uri.queryParameters["digits"] ?? "6") ?? 6;
      final period = int.tryParse(uri.queryParameters["period"] ?? "30") ?? 30;

      final account = Account(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: "$issuer: $accountName",
        secret: secret ?? "",
      );

      onAdd(account);
    }
  }
}
