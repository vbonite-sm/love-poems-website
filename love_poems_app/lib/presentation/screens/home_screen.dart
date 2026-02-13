import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';
import '../providers/poem_providers.dart';
import '../widgets/solid_background.dart';
import '../widgets/minimal_letter_card.dart';
import '../widgets/empty_state_card.dart';
import 'poem_view_screen.dart';
import 'archive_screen.dart';
import 'write_letter_screen.dart';
import 'profile_screen.dart';
import '../widgets/special_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SolidBackground(
        child: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: const [
              _HomeContent(),
              ArchiveScreen(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            activeIcon: Icon(Icons.mail),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Archive',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyLetter = ref.watch(dailyLetterProvider);

    return Stack(
      children: [
        // Main content
        Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Love Poems',
                  style: AppTheme.lightTheme.textTheme.displayMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'A letter awaits you...',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                _buildContent(context, ref, dailyLetter),
              ],
            ),
          ),
        ),
        // Write letter button (top-left)
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.sm,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WriteLetterScreen(),
                ),
              );
            },
            icon: const Icon(Icons.edit_note),
            color: AppColors.neutral800,
            tooltip: 'Write a letter',
          ),
        ),
        // Special message button (top-right)
        Positioned(
          top: AppSpacing.sm,
          right: AppSpacing.sm,
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const SpecialDialog(),
              );
            },
            icon: const Icon(Icons.favorite_outline),
            color: AppColors.accentRose,
            tooltip: 'Special message',
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, DailyLetterData dailyLetter) {
    switch (dailyLetter.state) {
      case DailyLetterState.loading:
        return const CircularProgressIndicator(
          color: AppColors.accentRose,
          strokeWidth: 2,
        );

      case DailyLetterState.sealed:
        return Column(
          children: [
            MinimalLetterCard(
              onTap: () async {
                await ref.read(dailyLetterProvider.notifier).openEnvelope();
                if (context.mounted) {
                  final newState = ref.read(dailyLetterProvider);
                  if (newState.state == DailyLetterState.opened &&
                      newState.currentPoem != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            PoemViewScreen(poem: newState.currentPoem!),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );

      case DailyLetterState.waitUntilTomorrow:
        return const EmptyStateCard();

      case DailyLetterState.opened:
        if (dailyLetter.currentPoem != null) {
          return Column(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PoemViewScreen(poem: dailyLetter.currentPoem!),
                    ),
                  );
                },
                icon: const Icon(Icons.mail_outline),
                label: const Text('Read Today\'s Poem'),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                dailyLetter.currentPoem!.title,
                style: AppTheme.poemTitle.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }
        return const EmptyStateCard();

      case DailyLetterState.error:
        return Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              dailyLetter.errorMessage ?? 'Something went wrong',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () => ref.read(dailyLetterProvider.notifier).reset(),
              child: const Text('Try Again'),
            ),
          ],
        );
    }
  }
}
