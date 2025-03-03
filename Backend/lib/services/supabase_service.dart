import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late final SupabaseClient _supabaseClient;

  Future<void> initialize(String supabaseUrl, String supabaseAnonKey) async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _supabaseClient = Supabase.instance.client;
  }

  SupabaseClient get client => _supabaseClient;
}
