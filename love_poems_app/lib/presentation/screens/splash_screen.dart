import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/solid_background.dart';
import 'sign_in_screen.dart';
import 'home_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      body: SolidBackground(
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
        // Heart icon (static)
        Icon(
          Icons.favorite_outline,
          size: 64,
          color: AppColors.accentRose,
        ),
        const SizedBox(height: AppSpacing.lg),
        // App title
        Text(
          'Love Poems',
          style: AppTheme.lightTheme.textTheme.displayLarge?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Letters from the heart',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xxl),
        // Loading indicator
        const CircularProgressIndicator(
          color: AppColors.accentRose,
          strokeWidth: 2,
        ),
      ],
    );
  }
}
