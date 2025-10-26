import "package:flutter/material.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/themes/app_colors.dart";

class AccountListItem extends StatelessWidget {
  final Account account;
  final String code;
  final int remainingSeconds;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const AccountListItem({
    super.key,
    required this.account,
    required this.code,
    required this.remainingSeconds,
    required this.onTap,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedCode = "${code.substring(0, 3)} ${code.substring(3)}";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(children: [Expanded(child: _buildAccountInfo(formattedCode))]),
        ),
      ),
    );
  }

  Widget _buildAccountInfo(String formattedCode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // account name
        Text(
          account.name,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),

        // code and timer
        Row(
          children: [
            // code
            Text(
              formattedCode,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),

            // spacing
            const SizedBox(width: 32),

            // timer
            _buildTimer(),
          ],
        ),
      ],
    );
  }

  Widget _buildTimer() {
    return SizedBox(
      width: 5,
      height: 5,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: remainingSeconds / 30.0),
        duration: const Duration(seconds: 1),
        builder: (_, value, _) =>
            CircularProgressIndicator(value: value, strokeWidth: 17),
      ),
    );
  }
}
