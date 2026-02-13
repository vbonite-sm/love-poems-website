import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/gradient_background.dart';
import 'sign_in_screen.dart';
import 'home_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: currentUserAsync.when(
            data: (user) {
              // Navigate based on auth state
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        user != null ? const HomeScreen() : const SignInScreen(),
                  ),
                );
              });

              return _buildSplashContent();
            },
            loading: () => _buildSplashContent(),
            error: (_, __) {
              // On error, go to sign in
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                );
              });

              return _buildSplashContent();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSplashContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Heart icon
        Icon(
          Icons.favorite,
          size: 80,
          color: AppColors.roseRouge,
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              duration: 1500.ms,
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.15, 1.15),
              curve: Curves.easeInOut,
            ),
        const SizedBox(height: 24),
        // App title
        Text(
          'Love Poems',
          style: AppTheme.lightTheme.textTheme.displayLarge?.copyWith(
            color: AppColors.deepPassion,
          ),
        ).animate().fadeIn(duration: 800.ms),
        const SizedBox(height: 8),
        Text(
          'Letters from the heart',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 800.ms),
        const SizedBox(height: 48),
        // Loading indicator
        const CircularProgressIndicator(
          color: AppColors.roseRouge,
        ),
      ],
    );
  }
}
