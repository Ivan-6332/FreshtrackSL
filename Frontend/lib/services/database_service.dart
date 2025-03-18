import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  // Get all crops with their demand
  Future<List<Map<String, dynamic>>> getCropsWithDemand() async {
    try {
      final response = await _supabase.from('crop').select('''
            crop_id,
            crop_name,
            crop_category,
            crop_pic,
            demand!inner (
              demand
            )
          ''').order('crop_name');

      List<Map<String, dynamic>> result = [];

      for (var crop in response) {
        if (crop is Map<String, dynamic>) {
          result.add({
            'id': crop['crop_id'],
            'name': crop['crop_name'],
            'category': crop['crop_category'],
            'pic': crop['crop_pic'],
            'demand': (crop['demand'] is List && crop['demand'].isNotEmpty)
                ? (crop['demand'][0]['demand'] is num
                    ? crop['demand'][0]['demand'].toDouble()
                    : 0.0)
                : 0.0,
            'isFavorited': false,
          });
        }
      }

      return result;
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

      final response = await _supabase.from('favorites').select('''
            crop_id,
            crop:crop_id (
              crop_id,
              crop_name,
              crop_category,
              crop_pic,
              demand:demand (
                demand
              )
            )
          ''').eq('user_id', userId);

      List<Map<String, dynamic>> result = [];

      for (var favorite in response) {
        if (favorite is Map<String, dynamic> &&
            favorite['crop'] is Map<String, dynamic>) {
          var crop = favorite['crop'];
          result.add({
            'id': crop['crop_id'],
            'name': crop['crop_name'],
            'category': crop['crop_category'],
            'pic': crop['crop_pic'],
            'demand': (crop['demand'] is List && crop['demand'].isNotEmpty)
                ? (crop['demand'][0]['demand'] is num
                    ? crop['demand'][0]['demand'].toDouble()
                    : 0.0)
                : 0.0,
            'isFavorited': true,
          });
        }
      }

      return result;
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
      Set<String> uniqueCategories = {};

      for (var item in response) {
        if (item is Map<String, dynamic> && item['crop_category'] is String) {
          uniqueCategories.add(item['crop_category']);
        }
      }

      List<String> sortedCategories = uniqueCategories.toList()..sort();

      List<Map<String, dynamic>> result = [];

      for (var category in sortedCategories) {
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

        result.add({
          'name': category,
          'icon': emoji,
        });
      }

      return result;
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }
}
