import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  // Get all crops with their demand
  Future<List<Map<String, dynamic>>> getCropsWithDemand({int? weekNo}) async {
    try {
      // If no week number is specified, use the current week
      final currentWeekNo = weekNo ?? _getCurrentWeekNumber();

      // Get all crops
      final cropsResponse = await _supabase.from('crop').select('*');

      if (cropsResponse == null) {
        throw Exception('Failed to fetch crops');
      }

      // Convert response to List<Map<String, dynamic>> if it's not already
      final List<Map<String, dynamic>> crops = cropsResponse is List
          ? List<Map<String, dynamic>>.from(cropsResponse.map(
              (item) => item is Map ? Map<String, dynamic>.from(item) : {}))
          : [];

      // For each crop, get its demand for the specified week
      for (var i = 0; i < crops.length; i++) {
        final cropId = crops[i]['crop_id'];

        // Get demand for the current crop and specified week
        final demandResponse = await _supabase
            .from('demand')
            .select('demand')
            .eq('crop_id', cropId)
            .eq('week_no', currentWeekNo)
            .maybeSingle();

        // Set the demand value or default to 0 if not found
        crops[i]['demand'] = demandResponse != null &&
                demandResponse['demand'] != null
            ? (demandResponse['demand'] is num ? demandResponse['demand'] : 0.0)
            : 0.0;
      }

      return crops;
    } catch (e) {
      print('Error fetching crops with demand: $e');
      throw Exception('Error fetching crops: $e');
    }
  }

  // Get user's favorite crops
  Future<List<Map<String, dynamic>>> getUserFavorites({int? weekNo}) async {
    try {
      // If no week number is specified, use the current week
      final currentWeekNo = weekNo ?? _getCurrentWeekNumber();

      // Get the current user's ID
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return [];
      }

      // Get the user's favorite crops
      final favoritesResponse = await _supabase
          .from('favorites')
          .select('crop_id')
          .eq('user_id', userId);

      if (favoritesResponse == null ||
          (favoritesResponse is List && favoritesResponse.isEmpty)) {
        return [];
      }

      // Extract crop_ids from the response
      final List<String> favoriteIds = [];
      if (favoritesResponse is List) {
        for (var item in favoritesResponse) {
          if (item is Map && item['crop_id'] != null) {
            favoriteIds.add(item['crop_id'].toString());
          }
        }
      }

      if (favoriteIds.isEmpty) {
        return [];
      }

      // Get the crop details for each favorite
      final cropsResponse =
          await _supabase.from('crop').select('*').in_('crop_id', favoriteIds);

      if (cropsResponse == null) {
        return [];
      }

      // Convert response to List<Map<String, dynamic>> if it's not already
      final List<Map<String, dynamic>> crops = cropsResponse is List
          ? List<Map<String, dynamic>>.from(cropsResponse.map(
              (item) => item is Map ? Map<String, dynamic>.from(item) : {}))
          : [];

      // For each crop, get its demand for the specified week
      for (var i = 0; i < crops.length; i++) {
        final cropId = crops[i]['crop_id'];

        // Get demand for the current crop and specified week
        final demandResponse = await _supabase
            .from('demand')
            .select('demand')
            .eq('crop_id', cropId)
            .eq('week_no', currentWeekNo)
            .maybeSingle();

        // Set the demand value or default to 0 if not found
        crops[i]['demand'] = demandResponse != null &&
                demandResponse['demand'] != null
            ? (demandResponse['demand'] is num ? demandResponse['demand'] : 0.0)
            : 0.0;

        // Mark as favorited
        crops[i]['isFavorited'] = true;
      }

      return crops;
    } catch (e) {
      print('Error fetching user favorites: $e');
      throw Exception('Error fetching favorites: $e');
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

  // Helper method to get the current week number (1-52)
  int _getCurrentWeekNumber() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(firstDayOfYear).inDays;
    return ((dayOfYear / 7) + 1).floor();
  }
}
