import "package:flutter/material.dart";
import "package:lechacals_authenticator/data/models/account.dart";
import "package:lechacals_authenticator/themes/app_colors.dart";

class AccountListItem extends StatelessWidget {
  final Account account;
  final String code;
  final String nextCode;
  final int remainingSeconds;
  final VoidCallback onTap;

  const AccountListItem({
    super.key,
    required this.account,
    required this.code,
    required this.nextCode,
    required this.remainingSeconds,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedCode = "${code.substring(0, 3)} ${code.substring(3)}";
    final formattedNextCode = "${nextCode.substring(0, 3)} ${nextCode.substring(3)}";

    return Card(
      // margin
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      // color

      // deco
      color: const Color.fromARGB(255, 28, 32, 44),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      // child
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAccountInfo(formattedCode, formattedNextCode),
              const SizedBox(height: 10),
              _buildProgressBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInfo(String formattedCode, String formattedNextCode) {
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

              Text(
                formattedCode,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),

        // time
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,

          // children
          children: [
            // remaining seconds
            Container(
              // padding
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

              // size
              width: 55,

              // decoration
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(33),
                borderRadius: BorderRadius.circular(8),
              ),

              // text
              child: Text(
                "${remainingSeconds}s",

                // align
                textAlign: TextAlign.end,

                // style
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ),

            // spacing
            const SizedBox(height: 16),

            // next code
            Text(
              "Next: $formattedNextCode",

              // style
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
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
