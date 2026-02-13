import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';

class ValentineLetter extends StatefulWidget {
  const ValentineLetter({super.key});

  @override
  State<ValentineLetter> createState() => _ValentineLetterState();
}

class _ValentineLetterState extends State<ValentineLetter> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    // Start confetti after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14 / 2, // downward
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.2,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.pink,
                Colors.white,
                Color(0xFFFF69B4), // Hot pink
                Color(0xFFDC143C), // Crimson
              ],
              createParticlePath: (size) {
                // Create heart shapes
                final path = Path();
                final heartSize = size.width;

                // Simple heart shape
                path.moveTo(heartSize / 2, heartSize / 4);
                path.cubicTo(
                  heartSize / 2,
                  0,
                  0,
                  0,
                  0,
                  heartSize / 4,
                );
                path.cubicTo(
                  0,
                  heartSize / 2,
                  heartSize / 2,
                  3 * heartSize / 4,
                  heartSize / 2,
                  heartSize,
                );
                path.cubicTo(
                  heartSize / 2,
                  3 * heartSize / 4,
                  heartSize,
                  heartSize / 2,
                  heartSize,
                  heartSize / 4,
                );
                path.cubicTo(
                  heartSize,
                  0,
                  heartSize / 2,
                  0,
                  heartSize / 2,
                  heartSize / 4,
                );

                return path;
              },
            ),
          ),

          // Letter content
          Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.antiqueWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.goldFoil,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.roseRouge.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Rose icon
                Icon(
                  Icons.local_florist,
                  size: 64,
                  color: AppColors.roseRouge,
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(duration: 2000.ms, begin: -0.05, end: 0.05)
                    .then()
                    .rotate(duration: 2000.ms, begin: 0.05, end: -0.05),

                const SizedBox(height: 24),

                // Title
                Text(
                  'Will You Be My Valentine?',
                  textAlign: TextAlign.center,
                  style: AppTheme.poemTitle.copyWith(
                    fontSize: 28,
                    color: AppColors.deepPassion,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2, end: 0),

                const SizedBox(height: 24),

                // Message
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      'In this garden of love we\'ve grown,\n'
                      'Where seeds of affection were sown,\n'
                      'Each day brings a letter, a sweet little token,\n'
                      'Of feelings so deep, yet unspoken.\n\n'
                      'With every word penned, every rhyme,\n'
                      'Our hearts beat together in time,\n'
                      'So on this day of love so divine,\n'
                      'I ask with all my heart...\n\n'
                      'Will you be mine? 💕',
                      textAlign: TextAlign.center,
                      style: AppTheme.poemBody.copyWith(
                        fontSize: 16,
                        height: 1.8,
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
                  ),
                ),

                const SizedBox(height: 32),

                // Decorative hearts
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.favorite,
                        size: 20,
                        color: AppColors.roseRouge,
                      )
                          .animate(delay: (index * 100).ms)
                          .fadeIn()
                          .scale(begin: const Offset(0, 0), end: const Offset(1, 1)),
                    );
                  }),
                ),

                const SizedBox(height: 24),

                // Close button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    backgroundColor: AppColors.roseRouge,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Forever & Always 💖',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms).scale(),
              ],
            ),
          ).animate().scale(
                duration: 500.ms,
                curve: Curves.elasticOut,
              ),
        ],
      ),
    );
  }
}
