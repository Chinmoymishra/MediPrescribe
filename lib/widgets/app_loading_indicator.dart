import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

class AppLoadingIndicator extends StatelessWidget {
  final String? message;
  final bool fullScreen;
  final double size;

  const AppLoadingIndicator({
    Key? key,
    this.message,
    this.fullScreen = false,
    this.size = 44,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _DualRingSpinner(size: size),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(message!, style: TextStyle(color: AppColors.secondaryText)),
        ],
      ],
    );

    if (fullScreen) {
      return Center(child: content);
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(child: content),
    );
  }
}

class _DualRingSpinner extends StatefulWidget {
  final double size;

  const _DualRingSpinner({required this.size});

  @override
  State<_DualRingSpinner> createState() => _DualRingSpinnerState();
}

class _DualRingSpinnerState extends State<_DualRingSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _DualRingPainter(progress: _controller.value),
          );
        },
      ),
    );
  }
}

class _DualRingPainter extends CustomPainter {
  final double progress;

  _DualRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;

    final outerPaint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.09
      ..strokeCap = StrokeCap.round;

    final innerPaint = Paint()
      ..color = AppColors.secondaryBlue.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.09
      ..strokeCap = StrokeCap.round;

    const outerSweep = 1.6 * 3.14159265;
    const innerSweep = 1.1 * 3.14159265;

    final outerStart = progress * 2 * 3.14159265;
    final innerStart = -progress * 2 * 3.14159265 * 1.4;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - outerPaint.strokeWidth / 2),
      outerStart,
      outerSweep,
      false,
      outerPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - outerPaint.strokeWidth * 2.1),
      innerStart,
      innerSweep,
      false,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DualRingPainter oldDelegate) => oldDelegate.progress != progress;
}
