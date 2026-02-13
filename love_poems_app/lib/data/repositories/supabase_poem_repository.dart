import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/poem.dart';

class SupabasePoemRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user ID
  String? get _currentUserId => _supabase.auth.currentUser?.id;

  // Get all public poems
  Future<List<Poem>> getAllPublicPoems() async {
    final response = await _supabase
        .from('poems')
        .select()
        .eq('is_public', true)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Poem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Get custom poems sent by partner
  Future<List<Poem>> getCustomPoemsFromPartner() async {
    if (_currentUserId == null) return [];

    // Get user's partner ID
    final profile = await _supabase
        .from('profiles')
        .select('partner_id')
        .eq('id', _currentUserId!)
        .maybeSingle();

    if (profile == null || profile['partner_id'] == null) {
      return [];
    }

    final partnerId = profile['partner_id'] as String;

    // Get poems sent by partner to current user
    final response = await _supabase
        .from('poems')
        .select()
        .eq('sender_id', partnerId)
        .eq('target_user_id', _currentUserId!)
        .eq('is_public', false)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Poem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Get unlocked poem IDs for current user
  Future<List<int>> getUnlockedPoemIds() async {
    if (_currentUserId == null) return [];

    final response = await _supabase
        .from('unlocked_poems')
        .select('poem_id')
        .eq('user_id', _currentUserId!);

    return (response as List)
        .map((item) => item['poem_id'] as int)
        .toList();
  }

  // Get unread poems (excluding unlocked ones)
  Future<List<Poem>> getUnreadPoems() async {
    final unlockedIds = await getUnlockedPoemIds();
    final allPublicPoems = await getAllPublicPoems();

    return allPublicPoems
        .where((poem) => !unlockedIds.contains(poem.id))
        .toList();
  }

  // Get unread custom poems from partner
  Future<List<Poem>> getUnreadCustomPoems() async {
    final unlockedIds = await getUnlockedPoemIds();
    final customPoems = await getCustomPoemsFromPartner();

    return customPoems
        .where((poem) => !unlockedIds.contains(poem.id))
        .toList();
  }

  // Get daily letter (prioritizes custom poems from partner)
  Future<Poem> getDailyLetter() async {
    // Priority 1: Check for unread custom poems from partner
    final unreadCustomPoems = await getUnreadCustomPoems();
    if (unreadCustomPoems.isNotEmpty) {
      unreadCustomPoems.shuffle();
      return unreadCustomPoems.first;
    }

    // Priority 2: Get random public poem
    final unreadPoems = await getUnreadPoems();
    if (unreadPoems.isEmpty) {
      throw Exception('No unread poems available');
    }

    unreadPoems.shuffle();
    return unreadPoems.first;
  }

  // Unlock a poem
  Future<void> unlockPoem(int poemId) async {
    if (_currentUserId == null) return;

    await _supabase.from('unlocked_poems').insert({
      'user_id': _currentUserId,
      'poem_id': poemId,
    });
  }

  // Get last opened date
  Future<DateTime?> getLastOpenedDate() async {
    if (_currentUserId == null) return null;

    final profile = await _supabase
        .from('profiles')
        .select('last_opened_date')
        .eq('id', _currentUserId!)
        .maybeSingle();

    if (profile == null || profile['last_opened_date'] == null) {
      return null;
    }

    return DateTime.parse(profile['last_opened_date'] as String);
  }

  // Set last opened date
  Future<void> setLastOpenedDate(DateTime date) async {
    if (_currentUserId == null) return;

    await _supabase.from('profiles').update({
      'last_opened_date': date.toIso8601String().split('T')[0], // Date only
    }).eq('id', _currentUserId!);
  }

  // Check if user can open new letter today
  Future<bool> canOpenNewLetter() async {
    final lastOpened = await getLastOpenedDate();
    if (lastOpened == null) return true;

    final now = DateTime.now();
    return !_isSameDay(lastOpened, now);
  }

  // Helper to check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Get all unlocked poems for archive
  Future<List<Poem>> getUnlockedPoems() async {
    if (_currentUserId == null) return [];

    final unlockedIds = await getUnlockedPoemIds();
    if (unlockedIds.isEmpty) return [];

    final response = await _supabase
        .from('poems')
        .select()
        .inFilter('id', unlockedIds)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Poem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Create custom poem (for write letter screen)
  Future<void> createCustomPoem({
    required String title,
    required String content,
    required String theme,
    required String targetUserId,
  }) async {
    if (_currentUserId == null) return;

    await _supabase.from('poems').insert({
      'title': title,
      'content': content,
      'author': 'You', // Could use display name from profile
      'theme': theme,
      'sender_id': _currentUserId,
      'target_user_id': targetUserId,
      'is_public': false,
    });
  }
}
