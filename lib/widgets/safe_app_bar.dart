import 'package:flutter/material.dart';
import '../styles.dart';
import 'safe_logo.dart';

class SafeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SafeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(121);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 21, top: 51),
        child: const SafeLogo(),
      ),
    );
  }
}
