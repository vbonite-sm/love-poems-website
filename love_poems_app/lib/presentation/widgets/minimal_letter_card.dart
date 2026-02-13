import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';

class MinimalLetterCard extends StatelessWidget {
  final VoidCallback? onTap;

  const MinimalLetterCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppElevation.medium,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline,
              size: 48,
              color: AppColors.accentRose,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Tap to open today\'s letter',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppColors.neutral600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
