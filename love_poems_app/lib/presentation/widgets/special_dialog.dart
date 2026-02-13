import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';

class SpecialDialog extends StatelessWidget {
  const SpecialDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.neutral200,
            width: 1,
          ),
          boxShadow: AppElevation.medium,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Heart icon (static)
            Icon(
              Icons.favorite_outline,
              size: 64,
              color: AppColors.accentRose,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              'Will You Be My Valentine?',
              textAlign: TextAlign.center,
              style: AppTheme.poemTitle.copyWith(
                fontSize: 28,
                color: AppColors.neutral900,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

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
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Close button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                backgroundColor: AppColors.accentRose,
                foregroundColor: AppColors.pureWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Forever & Always 💖',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
