import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.actions, this.backgroundColor, this.centerTitle = false, this.iconThemeData, this.leading, required this.text, this.textStyle});
  final Color? backgroundColor;
  final bool centerTitle;
  final IconThemeData? iconThemeData;
  final IconButton? leading;
  final String text;
  final TextStyle? textStyle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: leading == null? true:false,
      actions: actions,
      backgroundColor: backgroundColor?? AppStyle.white,
      centerTitle: centerTitle,
      elevation: 0,
      title: Text(
        text,
        style: textStyle ?? const TextStyle(color: AppStyle.primary, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      iconTheme: iconThemeData ?? const IconThemeData(color: AppStyle.primary),
      leading: leading,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}