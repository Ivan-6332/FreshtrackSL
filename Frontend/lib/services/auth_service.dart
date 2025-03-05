import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

class AuthService {
  final _supabase = SupabaseService().client;

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    required String province,
    required String district,
  }) async {
    try {
      // Sign up the user if sign
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign up failed');
      }

      // Call the stored procedure to register user
      await _supabase.rpc('register_user', params: {
        'user_id': response.user!.id,
        'user_email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'province': province,
        'district': district,
      });

      final now = DateTime.now();
      return UserModel(
        id: response.user!.id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        province: province,
        district: district,
        createdAt: now,
        updatedAt: now,
      );
    } catch (e) {
      throw Exception('Error during sign up: $e');
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed');
      }

      final userData = await _supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      // Log the sign in activity
      await _supabase.from('user_activity_logs').insert({
        'user_id': response.user!.id,
        'activity_type': 'SIGN_IN',
        'description': 'User signed in successfully'
      });

      return UserModel.fromJson(userData);
    } catch (e) {
      throw Exception('Error during sign in: $e');
    }
  }

  Future<void> signOut() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await _supabase.from('user_activity_logs').insert({
        'user_id': user.id,
        'activity_type': 'SIGN_OUT',
        'description': 'User signed out'
      });
    }
    await _supabase.auth.signOut();
  }

  Future<List<String>> getDistrictsByProvince(String province) async {
    try {
      final response = await _supabase
          .rpc('get_districts_by_province', params: {'p_province': province});

      return (response as List).map((district) => district.toString()).toList();
    } catch (e) {
      throw Exception('Error fetching districts: $e');
    }
  }
}
