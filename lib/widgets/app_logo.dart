import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({Key? key, this.size = 44}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final crossThickness = size * 0.22;
    final crossLength = size * 0.56;
    final dotSize = size * 0.2;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(size * AppRadius.lg / 48),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: crossLength,
            height: crossLength,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: crossThickness,
                  height: crossLength,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(crossThickness / 2),
                  ),
                ),
                Container(
                  width: crossLength,
                  height: crossThickness,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(crossThickness / 2),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: size * 0.16,
            right: size * 0.16,
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
