import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/poem_providers.dart';
import '../widgets/gradient_background.dart';

class WriteLetterScreen extends ConsumerStatefulWidget {
  const WriteLetterScreen({super.key});

  @override
  ConsumerState<WriteLetterScreen> createState() => _WriteLetterScreenState();
}

class _WriteLetterScreenState extends ConsumerState<WriteLetterScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _selectedTheme = 'romantic';

  final List<Map<String, dynamic>> _themes = [
    {'id': 'romantic', 'name': 'Romantic', 'icon': Icons.favorite},
    {'id': 'playful', 'name': 'Playful', 'icon': Icons.sentiment_very_satisfied},
    {'id': 'deep', 'name': 'Deep', 'icon': Icons.nights_stay},
    {'id': 'funny', 'name': 'Funny', 'icon': Icons.emoji_emotions},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
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
                    Expanded(
                      child: Text(
                        'Write a Letter',
                        style: AppTheme.lightTheme.textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title input
                      Text(
                        'Title',
                        style: AppTheme.lightTheme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.roseRouge.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'Give your letter a title...',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary.withValues(alpha: 0.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          style: AppTheme.poemTitle.copyWith(fontSize: 20),
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),

                      const SizedBox(height: 24),

                      // Theme selector
                      Text(
                        'Theme',
                        style: AppTheme.lightTheme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _themes.length,
                          itemBuilder: (context, index) {
                            final theme = _themes[index];
                            final isSelected = _selectedTheme == theme['id'];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _selectedTheme = theme['id']);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.roseRouge
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.roseRouge
                                          : AppColors.softBlush,
                                      width: 2,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.roseRouge
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        theme['icon'],
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.deepPassion,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        theme['name'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: 0.2, end: 0);
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Body input
                      Text(
                        'Your Letter',
                        style: AppTheme.lightTheme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: AppColors.antiqueWhite,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.roseRouge.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _bodyController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: 'Pour your heart out...',
                            hintStyle: AppTheme.poemBody.copyWith(
                              color: AppColors.textSecondary.withValues(alpha: 0.5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          style: AppTheme.poemBody,
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Send button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _sendLetter,
                    icon: const Icon(Icons.favorite),
                    label: const Text('Send to My Love'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.roseRouge,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendLetter() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in both title and letter'),
          backgroundColor: AppColors.deepPassion,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    // Get current user and their partner
    final user = ref.read(authProvider).user;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to send letters')),
        );
      }
      return;
    }

    final profileAsync = ref.read(userProfileProvider(user.id));
    final profile = await profileAsync.value;

    if (profile == null || profile['partner_id'] == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please link with your partner first in Profile'),
            backgroundColor: AppColors.deepPassion,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
      return;
    }

    try {
      // Save letter to Supabase
      final repository = ref.read(poemRepositoryProvider);
      await repository.createCustomPoem(
        title: _titleController.text.trim(),
        content: _bodyController.text.trim(),
        theme: _selectedTheme,
        targetUserId: profile['partner_id'] as String,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.favorite, color: Colors.white),
                SizedBox(width: 8),
                Text('Letter sent with love!'),
              ],
            ),
            backgroundColor: AppColors.roseRouge,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send letter: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
