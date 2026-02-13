import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/solid_background.dart';
import 'sign_in_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _partnerCodeController = TextEditingController();
  bool _isLinking = false;
  String? _linkError;

  @override
  void dispose() {
    _partnerCodeController.dispose();
    super.dispose();
  }

  Future<void> _linkPartner() async {
    final code = _partnerCodeController.text.trim().toUpperCase();
    if (code.isEmpty || code.length != 6) {
      setState(() {
        _linkError = 'Please enter a valid 6-character code';
      });
      return;
    }

    setState(() {
      _isLinking = true;
      _linkError = null;
    });

    try {
      final userId = ref.read(authProvider).user?.id;
      if (userId == null) {
        throw Exception('Not logged in');
      }

      final authRepo = ref.read(authRepositoryProvider);
      final success = await authRepo.linkPartnerByCode(userId, code);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Partner linked successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          _partnerCodeController.clear();
          // Refresh profile data
          ref.invalidate(userProfileProvider);
        }
      } else {
        setState(() {
          _linkError = 'Partner code not found';
        });
      }
    } catch (e) {
      setState(() {
        _linkError = 'Failed to link: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLinking = false;
      });
    }
  }

  Future<void> _signOut() async {
    await ref.read(authProvider.notifier).signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    final profileAsync = ref.watch(userProfileProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SolidBackground(
        child: SafeArea(
          child: profileAsync.when(
            data: (profile) => _buildProfileContent(profile, user.email ?? ''),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text('Error loading profile: $error'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(Map<String, dynamic>? profile, String email) {
    final displayName = profile?['display_name'] as String? ?? 'User';
    final partnerCode = profile?['partner_code'] as String? ?? 'XXXXXX';
    final partnerId = profile?['partner_id'] as String?;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),

          // Profile header
          const Icon(
            Icons.person,
            size: 80,
            color: AppColors.accentRose,
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            displayName,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.displayMedium,
          ),

          Text(
            email,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.neutral600,
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Your partner code card
          Container(
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppElevation.medium,
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Text(
                  'Your Partner Code',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.neutral200,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    partnerCode,
                    style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: AppColors.neutral900,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: partnerCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code copied to clipboard!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Code'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Share this code with your partner',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Partner status or link partner card
          if (partnerId != null)
            Container(
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.successGreen,
                  width: 2,
                ),
                boxShadow: AppElevation.medium,
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite,
                    size: 48,
                    color: AppColors.successGreen,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Partner Linked!',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppColors.successGreen,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'You can now send and receive custom love letters',
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral600,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppElevation.medium,
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Text(
                    'Link with Your Partner',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Enter your partner\'s code to start sending custom letters',
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: _partnerCodeController,
                    decoration: InputDecoration(
                      labelText: 'Partner Code',
                      hintText: 'ABCD12',
                      prefixIcon: const Icon(Icons.link),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorText: _linkError,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 6,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: _isLinking ? null : _linkPartner,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    child: _isLinking
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Link Partner'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
