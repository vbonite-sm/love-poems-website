import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';
import '../../data/models/poem.dart';

class LetterPaper extends StatelessWidget {
  final Poem poem;
  final bool showTitle;

  const LetterPaper({
    super.key,
    required this.poem,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.antiqueWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.roseRouge.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppColors.deepPassion.withValues(alpha: 0.1),
          width: 1,
        ),
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
            const SizedBox(height: 24),
            Container(
              width: 60,
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.roseRouge.withValues(alpha: 0),
                    AppColors.roseRouge,
                    AppColors.roseRouge.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Text(
            poem.content,
            style: AppTheme.poemBody,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
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
