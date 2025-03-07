import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class User {
  final String id;
  final String email;
  final String? username;
  final String? fullName;
  final String? avatarUrl;

  User({
    required this.id,
    required this.email,
    this.username,
    this.fullName,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
    );
  }
}

class AuthService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  User? _currentUser;
  bool _isLoading = false;
  String? _token;
  String? _error;

  // Backend API URL - replace with your actual URL
  final String apiUrl = 'http://192.168.1.102:3000/api';

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  String? get error => _error;

  AuthService() {
    _loadUserFromStorage();
  }

  // Load user data from secure storage
  Future<void> _loadUserFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await storage.read(key: 'auth_token');
      String? userData = await storage.read(key: 'user_data');

      if (_token != null && userData != null) {
        _currentUser = User.fromJson(jsonDecode(userData));
      }
    } catch (e) {
      _error = 'Failed to load user data';
      _token = null;
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign up new user
  Future<bool> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'full_name': fullName,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _token = data['token'];
        _currentUser = User.fromJson(data['user']);
        
        // Store user data and token
        await storage.write(key: 'auth_token', value: _token);
        await storage.write(key: 'user_data', value: jsonEncode(data['user']));
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = data['message'] ?? 'Failed to sign up';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Network error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login user
  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _token = data['token'];
        _currentUser = User.fromJson(data['user']);
        
        // Store user data and token
        await storage.write(key: 'auth_token', value: _token);
        await storage.write(key: 'user_data', value: jsonEncode(data['user']));
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = data['message'] ?? 'Failed to login';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Network error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_token != null) {
        await http.post(
          Uri.parse('$apiUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        );
      }
    } catch (e) {
      // Ignore errors on logout
    } finally {
      // Clear local storage regardless of API response
      await storage.delete(key: 'auth_token');
      await storage.delete(key: 'user_data');
      
      _token = null;
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get current user profile from API
  Future<void> getCurrentUser() async {
    if (_token == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _currentUser = User.fromJson(data['user']);
        await storage.write(key: 'user_data', value: jsonEncode(data['user']));
      } else {
        // Token might be invalid, clear auth data
        _error = data['message'];
        await logout();
      }
    } catch (e) {
      _error = 'Failed to fetch user profile';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
