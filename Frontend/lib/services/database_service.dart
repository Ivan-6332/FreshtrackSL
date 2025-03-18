import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  // Get all crops with their demand
  Future<List<Map<String, dynamic>>> getCropsWithDemand() async {
    try {
      final response = await _supabase
          .from('crop')
          .select('''
            crop_id,
            crop_name,
            crop_category,
            crop_pic,
            demand!inner (
              demand
            )
          ''')
          .order('crop_name');

      return response.map((crop) => {
        'id': crop['crop_id'],
        'name': crop['crop_name'],
        'category': crop['crop_category'],
        'pic': crop['crop_pic'],
        'demand': crop['demand'][0]['demand'].toDouble(),
      }).toList();
    } catch (e) {
      print('Error fetching crops: $e');
      rethrow;
    }
  }

  // Get user's favorite crops
  Future<List<Map<String, dynamic>>> getUserFavorites() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from('favorites')
          .select('''
            crop!inner (
              crop_id,
              crop_name,
              crop_category,
              crop_pic,
              demand!inner (
                demand
              )
            )
          ''')
          .eq('user_id', userId);

      return response.map((favorite) => {
        'id': favorite['crop']['crop_id'],
        'name': favorite['crop']['crop_name'],
        'category': favorite['crop']['crop_category'],
        'pic': favorite['crop']['crop_pic'],
        'demand': favorite['crop']['demand'][0]['demand'].toDouble(),
        'isFavorited': true,
      }).toList();
    } catch (e) {
      print('Error fetching favorites: $e');
      rethrow;
    }
  }

  // Get all categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await _supabase
          .from('crop')
          .select('crop_category')
          .order('crop_category');

      // Get unique categories and add emojis
      final uniqueCategories = response
          .map((item) => item['crop_category'] as String)
          .toSet()
          .toList()
        ..sort();

      return uniqueCategories.map((category) {
        String emoji = '🌱'; // Default emoji
        switch (category) {
          case 'leafy greens':
            emoji = '🥬';
            break;
          case 'root vegetables':
            emoji = '🥕';
            break;
          case 'fruiting vegetables':
            emoji = '🍅';
            break;
          case 'cruciferous vegetables':
            emoji = '🥦';
            break;
          case 'legumes & pods':
            emoji = '🫘';
            break;
          case 'bulb vegetables':
            emoji = '🧅';
            break;
          case 'spices':
            emoji = '🌶️';
            break;
          case 'grains':
            emoji = '🌾';
            break;
        }
        return {
          'name': category,
          'icon': emoji,
        };
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }
}

LOL