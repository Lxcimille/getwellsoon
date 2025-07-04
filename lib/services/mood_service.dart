import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/mood_entry.dart';

class MoodService {
  static final MoodService _instance = MoodService._internal();
  factory MoodService() => _instance;
  MoodService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();

  // Check if user is logged in
  bool get _isLoggedIn => _supabase.auth.currentUser != null;
  String? get _currentUserId => _supabase.auth.currentUser?.id;

  // Save mood entry to database
  Future<MoodEntry> saveMood({
    required String mood,
    String? detailedMood,
    String? note,
  }) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      final moodEntry = MoodEntry(
        id: _uuid.v4(),
        userId: _currentUserId!,
        mood: mood,
        detailedMood: detailedMood,
        note: note,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final response = await _supabase
          .from('mood_entries')
          .insert(moodEntry.toInsertJson())
          .select()
          .single();

      return MoodEntry.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get user's mood history
  Future<List<MoodEntry>> getMoodHistory({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      final response = await _supabase
          .from('mood_entries')
          .select()
          .eq('user_id', _currentUserId!)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => MoodEntry.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get mood entries for a specific date
  Future<List<MoodEntry>> getMoodByDate(DateTime date) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('mood_entries')
          .select()
          .eq('user_id', _currentUserId!)
          .gte('created_at', startOfDay.toIso8601String())
          .lt('created_at', endOfDay.toIso8601String())
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => MoodEntry.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get latest mood entry
  Future<MoodEntry?> getLatestMood() async {
    try {
      if (!_isLoggedIn) {
        return null;
      }

      final response = await _supabase
          .from('mood_entries')
          .select()
          .eq('user_id', _currentUserId!)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return MoodEntry.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Update mood entry
  Future<MoodEntry> updateMood({
    required String id,
    String? mood,
    String? detailedMood,
    String? note,
  }) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      final updates = <String, dynamic>{};
      if (mood != null) updates['mood'] = mood;
      if (detailedMood != null) updates['detailed_mood'] = detailedMood;
      if (note != null) updates['note'] = note;
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('mood_entries')
          .update(updates)
          .eq('id', id)
          .eq('user_id', _currentUserId!)
          .select()
          .single();

      return MoodEntry.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Delete mood entry
  Future<void> deleteMood(String id) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      await _supabase
          .from('mood_entries')
          .delete()
          .eq('id', id)
          .eq('user_id', _currentUserId!);
    } catch (e) {
      rethrow;
    }
  }

  // Get mood statistics
  Future<Map<String, int>> getMoodStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      var query = _supabase
          .from('mood_entries')
          .select('mood')
          .eq('user_id', _currentUserId!);

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lt('created_at', endDate.toIso8601String());
      }

      final response = await query;
      
      final Map<String, int> statistics = {};
      for (final item in response) {
        final mood = item['mood'] as String;
        statistics[mood] = (statistics[mood] ?? 0) + 1;
      }

      return statistics;
    } catch (e) {
      rethrow;
    }
  }

  // Check if user has logged mood today
  Future<bool> hasMoodToday() async {
    try {
      if (!_isLoggedIn) {
        return false;
      }

      final today = DateTime.now();
      final todayMoods = await getMoodByDate(today);
      return todayMoods.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
} 