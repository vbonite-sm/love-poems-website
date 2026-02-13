import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: displayName != null ? {'display_name': displayName} : null,
    );

    // Create profile if sign up successful
    if (response.user != null) {
      await _createProfile(response.user!.id, displayName);
    }

    return response;
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign in with magic link
  Future<void> signInWithMagicLink(String email) async {
    await _supabase.auth.signInWithOtp(email: email);
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Create user profile
  Future<void> _createProfile(String userId, String? displayName) async {
    await _supabase.from('profiles').insert({
      'id': userId,
      'display_name': displayName ?? 'Anonymous',
      'partner_code': _generatePartnerCode(),
    });
  }

  // Generate unique partner code (6 characters)
  String _generatePartnerCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Removed confusing chars
    final random = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    int seed = random;

    for (int i = 0; i < 6; i++) {
      code += chars[seed % chars.length];
      seed = seed ~/ chars.length;
    }

    return code;
  }

  // Get user profile
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  // Update profile
  Future<void> updateProfile({
    required String userId,
    String? displayName,
    String? partnerId,
  }) async {
    final updates = <String, dynamic>{};
    if (displayName != null) updates['display_name'] = displayName;
    if (partnerId != null) updates['partner_id'] = partnerId;

    await _supabase.from('profiles').update(updates).eq('id', userId);
  }

  // Link partner by code
  Future<bool> linkPartnerByCode(String userId, String partnerCode) async {
    // Find partner by code
    final partnerProfile = await _supabase
        .from('profiles')
        .select()
        .eq('partner_code', partnerCode)
        .maybeSingle();

    if (partnerProfile == null) {
      return false; // Partner not found
    }

    final partnerId = partnerProfile['id'] as String;

    // Update both profiles
    await updateProfile(userId: userId, partnerId: partnerId);
    await updateProfile(userId: partnerId, partnerId: userId);

    return true;
  }
}
