import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_colors.dart';

class SealedEnvelope extends StatelessWidget {
  final VoidCallback? onTap;

  const SealedEnvelope({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.antiqueWhite,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.roseRouge.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Envelope body
            CustomPaint(
              size: const Size(280, 200),
              painter: _EnvelopePainter(),
            ),
            // Wax seal
            Positioned(
              top: 60,
              child: _WaxSeal(),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaxSeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.waxSealGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.deepPassion.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '\u2764',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          duration: 1500.ms,
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.08, 1.08),
          curve: Curves.easeInOut,
        )
        .shimmer(
          duration: 2000.ms,
          color: Colors.white.withValues(alpha: 0.3),
        );
  }
}

class _EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFE4C4)
      ..style = PaintingStyle.fill;

    // Envelope flap (triangle)
    final flapPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height * 0.45)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(flapPath, paint);

    // Border
    final borderPaint = Paint()
      ..color = AppColors.deepPassion.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(flapPath, borderPaint);

    // Envelope body border
    final bodyPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0);

    canvas.drawPath(bodyPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
