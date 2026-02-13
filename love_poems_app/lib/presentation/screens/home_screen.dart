import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';
import '../providers/poem_providers.dart';
import '../widgets/gradient_background.dart';
import '../widgets/sealed_envelope.dart';
import '../widgets/open_envelope.dart';
import 'poem_view_screen.dart';
import 'archive_screen.dart';
import 'write_letter_screen.dart';
import 'profile_screen.dart';
import '../widgets/valentine_letter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: const [
              _HomeContent(),
              ArchiveScreen(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const ValentineLetter(),
          );
        },
        backgroundColor: AppColors.roseRouge,
        elevation: 8,
        child: Icon(
          Icons.local_florist,
          color: Colors.white,
          size: 32,
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              duration: 1500.ms,
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.15, 1.15),
              curve: Curves.easeInOut,
            ),
      ).animate().fadeIn(delay: 1000.ms).scale(
            begin: const Offset(0, 0),
            end: const Offset(1, 1),
            curve: Curves.elasticOut,
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedIndex = 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedIndex == 0 ? Icons.mail : Icons.mail_outline,
                        color: _selectedIndex == 0
                            ? AppColors.roseRouge
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedIndex == 0
                              ? AppColors.roseRouge
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 80), // Space for FAB
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedIndex = 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedIndex == 1
                            ? Icons.folder
                            : Icons.folder_open_outlined,
                        color: _selectedIndex == 1
                            ? AppColors.roseRouge
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Archive',
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedIndex == 1
                              ? AppColors.roseRouge
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Love Poems',
                  style: AppTheme.lightTheme.textTheme.displayMedium,
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
                const SizedBox(height: 8),
                Text(
                  'A letter awaits you...',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                const SizedBox(height: 48),
                _buildContent(context, ref, dailyLetter),
              ],
            ),
          ),
        ),
        // Write letter button (quill icon)
        Positioned(
          top: 8,
          left: 8,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const WriteLetterScreen(),
                ),
              );
            },
            icon: const Icon(Icons.edit_note),
            color: AppColors.deepPassion,
            tooltip: 'Write a letter',
          ).animate().fadeIn(delay: 600.ms),
        ),
        // Profile button
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            icon: const Icon(Icons.person_outline),
            color: AppColors.deepPassion,
            tooltip: 'Profile',
          ).animate().fadeIn(delay: 600.ms),
        ),
      ],
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, DailyLetterData dailyLetter) {
    switch (dailyLetter.state) {
      case DailyLetterState.loading:
        return const CircularProgressIndicator(
          color: AppColors.roseRouge,
        );

      case DailyLetterState.sealed:
        return Column(
          children: [
            SealedEnvelope(
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
            ).animate().fadeIn(delay: 400.ms, duration: 800.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  curve: Curves.easeOutBack,
                ),
            const SizedBox(height: 24),
            Text(
              'Tap to open',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn().then().fadeOut(),
          ],
        );

      case DailyLetterState.waitUntilTomorrow:
        return const OpenEnvelope()
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));

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
              const SizedBox(height: 16),
              Text(
                dailyLetter.currentPoem!.title,
                style: AppTheme.poemTitle.copyWith(fontSize: 20),
              ),
            ],
          );
        }
        return const OpenEnvelope();

      case DailyLetterState.error:
        return Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.deepPassion.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              dailyLetter.errorMessage ?? 'Something went wrong',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(dailyLetterProvider.notifier).reset(),
              child: const Text('Try Again'),
            ),
          ],
        );
    }
  }
}
