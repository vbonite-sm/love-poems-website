import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_colors.dart';
import '../../config/app_theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/gradient_background.dart';
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
      body: GradientBackground(
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
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),

          // Profile header
          Icon(
            Icons.person,
            size: 80,
            color: AppColors.roseRouge,
          ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),

          const SizedBox(height: 16),

          Text(
            displayName,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.displayMedium,
          ).animate().fadeIn(delay: 300.ms),

          Text(
            email,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 48),

          // Your partner code card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    'Your Partner Code',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppColors.deepPassion,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.softBlush,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.roseRouge,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      partnerCode,
                      style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                        color: AppColors.deepPassion,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                      foregroundColor: AppColors.deepPassion,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Share this code with your partner',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: 24),

          // Partner status or link partner card
          if (partnerId != null)
            Card(
              elevation: 4,
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 48,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Partner Linked!',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You can now send and receive custom love letters',
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 600.ms).scale()
          else
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Link with Your Partner',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppColors.deepPassion,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Enter your partner\'s code to start sending custom letters',
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLinking ? null : _linkPartner,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
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
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}
