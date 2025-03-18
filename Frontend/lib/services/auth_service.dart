import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomUser {
  // Renamed to avoid conflict with Supabase User
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? province;
  final String? district;

  CustomUser({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.province,
    this.district,
  });

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      phone: json['phone']?.toString(),
      province: json['province']?.toString(),
      district: json['district']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'province': province,
      'district': district,
    };
  }

  static Future<CustomUser> fromSupabaseUser(User? supabaseUser) async {
    if (supabaseUser == null) {
      throw Exception('User is null');
    }

    final supabase = Supabase.instance.client;

    try {
      final userData = await supabase
          .from('profiles')
          .select()
          .eq('id', supabaseUser.id)
          .single();

      return CustomUser.fromJson({
        ...userData,
        'id': supabaseUser.id,
        'email': supabaseUser.email ?? '',
      });
    } catch (e) {
      // Return basic user if detailed data isn't available
      return CustomUser(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
      );
    }
  }
}

class AuthService extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  final _storage = const FlutterSecureStorage();
  CustomUser? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthService() {
    _initializeAuth();
  }

  CustomUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get error => _error;

  Future<void> _initializeAuth() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      try {
        _currentUser = await CustomUser.fromSupabaseUser(session.user);
        notifyListeners();
      } catch (e) {
        _error = _handleAuthError(e);
      }
    }

    _supabase.auth.onAuthStateChange.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn && event.session != null) {
        try {
          _currentUser = await CustomUser.fromSupabaseUser(event.session!.user);
          await _storage.write(
            key: 'user_data',
            value: jsonEncode(_currentUser!.toJson()),
          );
        } catch (e) {
          _error = _handleAuthError(e);
        }
      } else if (event.event == AuthChangeEvent.signedOut) {
        _currentUser = null;
        await _storage.delete(key: 'user_data');
      }
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Failed to sign in');
      }

      _currentUser = await CustomUser.fromSupabaseUser(response.user);
    } catch (e) {
      _error = _handleAuthError(e);
      throw _error!;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: userData,
      );

      if (response.user != null) {
        _currentUser = await CustomUser.fromSupabaseUser(response.user);
      }
    } catch (e) {
      _error = _handleAuthError(e);
      throw _error!;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _supabase.auth.signOut();
      _currentUser = null;
      await _storage.delete(key: 'user_data');
    } catch (e) {
      _error = _handleAuthError(e);
      throw _error!;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _handleAuthError(dynamic error) {
    if (error is AuthException) {
      return error.message;
    } else if (error is PostgrestException) {
      return 'Database error: ${error.message}';
    }
    return 'An unexpected error occurred';
  }
}
