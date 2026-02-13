import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';
import '../../data/models/poem.dart';

class MinimalPoemCard extends StatelessWidget {
  final Poem poem;
  final bool showTitle;

  const MinimalPoemCard({
    super.key,
    required this.poem,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppElevation.medium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showTitle) ...[
            Text(
              poem.title,
              style: AppTheme.poemTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: 60,
              height: 1,
              color: AppColors.neutral200,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          Text(
            poem.content,
            style: AppTheme.poemBody,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'With Love',
            style: AppTheme.poemSignature,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
