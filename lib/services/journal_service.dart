import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/journalentry.dart';

class JournalService {
  static final JournalService _instance = JournalService._internal();
  factory JournalService() => _instance;
  JournalService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();
  final ImagePicker _imagePicker = ImagePicker();

  // Check if user is logged in
  bool get _isLoggedIn => _supabase.auth.currentUser != null;
  String? get _currentUserId => _supabase.auth.currentUser?.id;

  // Save journal entry to database
  Future<JournalEntry> saveJournal({
    required String content,
    List<String>? imageUrls,
  }) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      final now = DateTime.now();
      final journalEntry = JournalEntry.database(
        id: _uuid.v4(),
        userId: _currentUserId!,
        content: content,
        createdAt: now,
        updatedAt: now,
        imageUrls: imageUrls,
      );

      // Note: For now we'll store content only as per current database schema
      // Image URLs will be added when we enhance the database schema
      final insertData = {
        'user_id': _currentUserId!,
        'content': content,
      };

      final response = await _supabase
          .from('journal_entries')
          .insert(insertData)
          .select()
          .single();

      return JournalEntry.fromDatabaseJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get user's journal history
  Future<List<JournalEntry>> getJournalHistory({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      final response = await _supabase
          .from('journal_entries')
          .select()
          .eq('user_id', _currentUserId!)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => JournalEntry.fromDatabaseJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get journal entries for a specific date
  Future<List<JournalEntry>> getJournalByDate(DateTime date) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('journal_entries')
          .select()
          .eq('user_id', _currentUserId!)
          .gte('created_at', startOfDay.toIso8601String())
          .lt('created_at', endOfDay.toIso8601String())
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => JournalEntry.fromDatabaseJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get latest journal entry
  Future<JournalEntry?> getLatestJournal() async {
    try {
      if (!_isLoggedIn) {
        return null;
      }

      final response = await _supabase
          .from('journal_entries')
          .select()
          .eq('user_id', _currentUserId!)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return JournalEntry.fromDatabaseJson(response);
    } catch (e) {
      return null;
    }
  }

  // Update journal entry
  Future<JournalEntry> updateJournal({
    required String id,
    String? content,
    List<String>? imageUrls,
  }) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      final updates = <String, dynamic>{};
      if (content != null) updates['content'] = content;
      // Note: image_urls will be added when we enhance database schema
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('journal_entries')
          .update(updates)
          .eq('id', id)
          .eq('user_id', _currentUserId!)
          .select()
          .single();

      return JournalEntry.fromDatabaseJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Delete journal entry
  Future<void> deleteJournal(String id) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      await _supabase
          .from('journal_entries')
          .delete()
          .eq('id', id)
          .eq('user_id', _currentUserId!);
    } catch (e) {
      rethrow;
    }
  }

  // Pick image from gallery
  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      rethrow;
    }
  }

  // Pick image from camera
  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      rethrow;
    }
  }

  // Pick multiple images from gallery
  Future<List<XFile>?> pickMultipleImages() async {
    try {
      final List<XFile>? images = await _imagePicker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      return images;
    } catch (e) {
      rethrow;
    }
  }

  // Upload image to Supabase storage
  Future<String> uploadImage(XFile imageFile) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      // Create unique filename
      final String fileName = '${_currentUserId}_${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      final String filePath = 'journal_images/$fileName';

      // Upload file to Supabase storage
      await _supabase.storage
          .from('journal-images')
          .upload(filePath, File(imageFile.path));

      // Get public URL
      final String publicUrl = _supabase.storage
          .from('journal-images')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Upload multiple images
  Future<List<String>> uploadMultipleImages(List<XFile> imageFiles) async {
    try {
      List<String> uploadedUrls = [];
      
      for (XFile imageFile in imageFiles) {
        final String url = await uploadImage(imageFile);
        uploadedUrls.add(url);
      }
      
      return uploadedUrls;
    } catch (e) {
      rethrow;
    }
  }

  // Delete image from storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      // Extract file path from URL
      final Uri uri = Uri.parse(imageUrl);
      final String filePath = uri.pathSegments.last;
      
      await _supabase.storage
          .from('journal-images')
          .remove(['journal_images/$filePath']);
    } catch (e) {
      rethrow;
    }
  }

  // Get journal statistics
  Future<Map<String, dynamic>> getJournalStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (!_isLoggedIn) {
        throw Exception('User not logged in');
      }

      var query = _supabase
          .from('journal_entries')
          .select('created_at, content')
          .eq('user_id', _currentUserId!);

      if (startDate != null) {
        query = query.gte('created_at', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lt('created_at', endDate.toIso8601String());
      }

      final response = await query;
      
      int totalEntries = response.length;
      int totalWords = 0;
      
      for (final item in response) {
        final content = item['content'] as String;
        totalWords += content.split(' ').length;
      }

      return {
        'totalEntries': totalEntries,
        'totalWords': totalWords,
        'averageWordsPerEntry': totalEntries > 0 ? totalWords / totalEntries : 0,
      };
    } catch (e) {
      rethrow;
    }
  }

  // Check if user has journaled today
  Future<bool> hasJournaledToday() async {
    try {
      if (!_isLoggedIn) {
        return false;
      }

      final today = DateTime.now();
      final todayJournals = await getJournalByDate(today);
      return todayJournals.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
} 