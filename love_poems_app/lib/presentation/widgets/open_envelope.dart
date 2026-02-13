import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';

class OpenEnvelope extends StatelessWidget {
  final VoidCallback? onTap;

  const OpenEnvelope({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 200,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.antiqueWhite.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.deepPassion.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Sleeping cupid icon
                Icon(
                  Icons.bedtime_outlined,
                  size: 48,
                  color: AppColors.deepPassion.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Come back tomorrow',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppColors.deepPassion.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'for more love...',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
