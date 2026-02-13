import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';
import '../../data/models/poem.dart';
import '../providers/poem_providers.dart';
import 'poem_view_screen.dart';

class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archiveAsync = ref.watch(archiveProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Letters',
            style: AppTheme.lightTheme.textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'All the love you\'ve collected',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: archiveAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentRose,
                  strokeWidth: 2,
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.neutral400,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Could not load archive',
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              data: (poems) {
                if (poems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 64,
                          color: AppColors.neutral400,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No letters yet',
                          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.neutral600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Open your first envelope to start collecting',
                          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: poems.length,
                  itemBuilder: (context, index) {
                    return _ArchiveCard(
                      poem: poems[index],
                      index: index,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchiveCard extends StatelessWidget {
  final Poem poem;
  final int index;

  const _ArchiveCard({required this.poem, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PoemViewScreen(poem: poem),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppElevation.subtle,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background envelope icon
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  Icons.mail,
                  size: 100,
                  color: AppColors.neutral200,
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neutral100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#${poem.id}',
                        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppColors.neutral600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      poem.title,
                      style: AppTheme.poemTitle.copyWith(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 14,
                          color: AppColors.accentRose,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Read',
                          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
