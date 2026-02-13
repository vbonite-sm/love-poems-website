import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';
import '../../data/models/poem.dart';
import '../widgets/solid_background.dart';
import '../widgets/minimal_poem_card.dart';

class PoemViewScreen extends StatelessWidget {
  final Poem poem;

  const PoemViewScreen({super.key, required this.poem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SolidBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios),
                      color: AppColors.neutral800,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // Static heart button - no confetti
                      },
                      icon: const Icon(Icons.favorite_outline),
                      color: AppColors.accentRose,
                    ),
                  ],
                ),
              ),
              // Letter content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: MinimalPoemCard(poem: poem),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
