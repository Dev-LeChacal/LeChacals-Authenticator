import "package:flutter/material.dart";
import "package:lechacals_authenticator/widgets/customs/action_button.dart";

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;

  final ActionButtonParams? leftAction;
  final ActionButtonParams? rightAction;

  const CustomAppBar({
    super.key,
    required this.title,
    this.height = 60,
    this.leftAction,
    this.rightAction,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Left side
              if (leftAction != null)
                Flexible(
                  child: Row(children: [ActionButton(params: leftAction!)]),
                ),

              // Center
              Flexible(
                flex: 2,
                child: Center(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              // Right side
              if (rightAction != null)
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [ActionButton(params: rightAction!)],
                  ),
                ),

              if (rightAction == null && leftAction != null) const Spacer(),
            ],
          );
        },
      ),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
