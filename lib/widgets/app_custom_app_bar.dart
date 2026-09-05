import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/app_spacing.dart';

class AppCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;

  const AppCustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.leading,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.headlineLarge,
      ),
      backgroundColor: backgroundColor ?? AppColors.card,
      elevation: 0,
      leading: showBackButton
          ? leading ??
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: AppColors.primaryText,
                ),
                onPressed: onBackPressed ??
                    () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/welcome');
                      }
                    },
              )
          : leading,
      actions: actions,
      centerTitle: false,
      foregroundColor: AppColors.primaryText,
      surfaceTintColor: backgroundColor ?? AppColors.card,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
