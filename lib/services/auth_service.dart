import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _supabase.auth.currentUser != null;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) async {
    try {
      // First check if user already exists
      final existingUser = await _supabase
          .from('profiles')
          .select()
          .eq('email', email)
          .maybeSingle()
          .catchError((_) => null);

      if (existingUser != null) {
        throw Exception(
          'A user with this email already exists. Please log in instead.',
        );
      }

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'username': username},
      );

      if (response.user != null) {
        try {
          // Try to insert the profile
          await _supabase.from('profiles').insert({
            'id': response.user!.id,
            'full_name': fullName,
            'username': username,
            'email': email,
            'created_at': DateTime.now().toIso8601String(),
          });
        } catch (e) {
          // If profile already exists, update it instead
          if (e.toString().contains('duplicate key')) {
            await _supabase
                .from('profiles')
                .update({
                  'full_name': fullName,
                  'username': username,
                  'email': email,
                  'updated_at': DateTime.now().toIso8601String(),
                })
                .eq('id', response.user!.id);
          } else {
            rethrow;
          }
        }
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();

      // Clear local preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (!isLoggedIn) return null;

      final response =
          await _supabase
              .from('profiles')
              .select()
              .eq('id', currentUser!.id)
              .single();

      return response;
    } catch (e) {
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({String? fullName, String? username}) async {
    try {
      if (!isLoggedIn) throw Exception('User not logged in');

      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (username != null) updates['username'] = username;
      updates['updated_at'] = DateTime.now().toIso8601String();

      await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', currentUser!.id);
    } catch (e) {
      rethrow;
    }
  }

  // Listen to auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
