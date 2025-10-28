import "package:flutter/material.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/themes/app_colors.dart";

class AccountListItem extends StatelessWidget {
  final Account account;
  final String code;
  final int remainingSeconds;
  final VoidCallback onTap;

  const AccountListItem({
    super.key,
    required this.account,
    required this.code,
    required this.remainingSeconds,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedCode = "${code.substring(0, 3)} ${code.substring(3)}";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: const Color.fromARGB(255, 28, 32, 44),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAccountInfo(formattedCode),
              const SizedBox(height: 12),
              _buildProgressBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInfo(String formattedCode) {
    return Row(
      // alignments
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,

      // children
      children: [
        // name, code
        Expanded(
          child: Column(
            // alignment
            crossAxisAlignment: CrossAxisAlignment.start,

            // children
            children: [
              // name
              Text(
                account.name,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),

              // spacing
              const SizedBox(height: 4),

              // code
              Text(
                formattedCode,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),

        // time
        Container(
          // padding
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

          // decoration
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(33),
            borderRadius: BorderRadius.circular(8),
          ),

          // text
          child: Text(
            "${remainingSeconds}s",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = remainingSeconds / 30.0;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: progress, end: progress),
      duration: const Duration(milliseconds: 300),

      // builder
      builder: (context, value, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: Colors.white.withAlpha(33),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        );
      },
    );
  }
}
