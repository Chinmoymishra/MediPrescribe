import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_text_styles.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final VoidCallback? onCenterActionTap;
  final IconData centerActionIcon;

  const AppBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.onCenterActionTap,
    this.centerActionIcon = Icons.add_rounded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final splitIndex = (items.length / 2).ceil();
    final leftItems = items.sublist(0, splitIndex);
    final rightItems = items.sublist(splitIndex);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.xxxl),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.14),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...List.generate(leftItems.length, (index) {
              final selected = index == currentIndex;
              final item = leftItems[index];
              return Expanded(
                child: _NavItem(
                  selected: selected,
                  icon: selected ? (item.activeIcon as Icon) : (item.icon as Icon),
                  label: item.label ?? '',
                  onTap: () => onTap(index),
                ),
              );
            }),
            if (onCenterActionTap != null)
              _CenterActionButton(icon: centerActionIcon, onTap: onCenterActionTap!),
            ...List.generate(rightItems.length, (i) {
              final index = splitIndex + i;
              final selected = index == currentIndex;
              final item = rightItems[i];
              return Expanded(
                child: _NavItem(
                  selected: selected,
                  icon: selected ? (item.activeIcon as Icon) : (item.icon as Icon),
                  label: item.label ?? '',
                  onTap: () => onTap(index),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _CenterActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CenterActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
}

class _NavItem extends StatelessWidget {
  final bool selected;
  final Icon icon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: EdgeInsets.symmetric(horizontal: selected ? 14 : 0, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.lightBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(
                color: selected ? AppColors.primaryBlue : AppColors.secondaryText,
                size: 22,
              ),
              child: icon,
            ),
            if (selected)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    label,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
}
