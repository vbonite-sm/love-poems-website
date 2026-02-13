import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../../config/app_colors.dart';
import '../../data/models/poem.dart';
import '../widgets/gradient_background.dart';
import '../widgets/letter_paper.dart';

class PoemViewScreen extends StatefulWidget {
  final Poem poem;

  const PoemViewScreen({super.key, required this.poem});

  @override
  State<PoemViewScreen> createState() => _PoemViewScreenState();
}

class _PoemViewScreenState extends State<PoemViewScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    // Play confetti on first open
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // App bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios),
                          color: AppColors.deepPassion,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _confettiController.play(),
                          icon: const Icon(Icons.favorite),
                          color: AppColors.roseRouge,
                        ),
                      ],
                    ),
                  ),
                  // Letter content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: LetterPaper(poem: widget.poem)
                          .animate()
                          .fadeIn(duration: 800.ms)
                          .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                    ),
                  ),
                ],
              ),
            ),
            // Confetti overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.03,
                numberOfParticles: 20,
                maxBlastForce: 30,
                minBlastForce: 10,
                gravity: 0.2,
                particleDrag: 0.05,
                colors: const [
                  AppColors.roseRouge,
                  AppColors.goldFoil,
                  AppColors.softBlush,
                  Colors.white,
                  AppColors.deepPassion,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
