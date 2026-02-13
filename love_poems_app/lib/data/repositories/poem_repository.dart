import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/poem.dart';

class PoemRepository {
  static const String _unlockedPoemsKey = 'unlocked_poem_ids';
  static const String _lastOpenedDateKey = 'last_opened_date';

  List<Poem>? _cachedPoems;

  Future<List<Poem>> loadAllPoems() async {
    if (_cachedPoems != null) return _cachedPoems!;

    final String jsonString =
        await rootBundle.loadString('assets/data/poems.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final List<dynamic> poemsJson = data['poems'] as List<dynamic>;

    _cachedPoems =
        poemsJson.map((json) => Poem.fromJson(json as Map<String, dynamic>)).toList();

    return _cachedPoems!;
  }

  Future<Set<int>> getUnlockedPoemIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? ids = prefs.getStringList(_unlockedPoemsKey);
    if (ids == null) return {};
    return ids.map((id) => int.parse(id)).toSet();
  }

  Future<void> unlockPoem(int poemId) async {
    final prefs = await SharedPreferences.getInstance();
    final Set<int> unlockedIds = await getUnlockedPoemIds();
    unlockedIds.add(poemId);
    await prefs.setStringList(
      _unlockedPoemsKey,
      unlockedIds.map((id) => id.toString()).toList(),
    );
  }

  Future<DateTime?> getLastOpenedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dateStr = prefs.getString(_lastOpenedDateKey);
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  Future<void> setLastOpenedDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastOpenedDateKey, date.toIso8601String());
  }

  Future<List<Poem>> getUnlockedPoems() async {
    final allPoems = await loadAllPoems();
    final unlockedIds = await getUnlockedPoemIds();

    return allPoems.where((poem) => unlockedIds.contains(poem.id)).toList();
  }

  Future<Poem?> getRandomUnreadPoem() async {
    final allPoems = await loadAllPoems();
    final unlockedIds = await getUnlockedPoemIds();

    final unreadPoems =
        allPoems.where((poem) => !unlockedIds.contains(poem.id)).toList();

    if (unreadPoems.isEmpty) {
      // All poems read, return random from all
      if (allPoems.isEmpty) return null;
      return allPoems[Random().nextInt(allPoems.length)];
    }

    return unreadPoems[Random().nextInt(unreadPoems.length)];
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<bool> canOpenNewLetter() async {
    final lastOpened = await getLastOpenedDate();
    if (lastOpened == null) return true;
    return !isSameDay(lastOpened, DateTime.now());
  }
}
