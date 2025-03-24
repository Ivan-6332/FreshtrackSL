import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  // Cache storage
  final Map<String, List<Map<String, dynamic>>> _cropCache =
      {}; // Cache for crops by week
  final Map<String, List<Map<String, dynamic>>> _favoriteCache =
      {}; // Cache for favorites by week
  List<Map<String, dynamic>>? _categoriesCache; // Cache for categories
  // Cache for weekly demand data for crops
  final Map<String, Map<int, double>> _weeklyDemandCache = {};

  // Get all crops with their demand - optimized with batched queries and caching
  Future<List<Map<String, dynamic>>> getCropsWithDemand({int? weekNo}) async {
    try {
      // If no week number is specified, use the current week
      final currentWeekNo = weekNo ?? _getCurrentWeekNumber();

      // Check if we have this data in cache
      final cacheKey = 'week_$currentWeekNo';
      if (_cropCache.containsKey(cacheKey)) {
        return _cropCache[cacheKey]!;
      }

      // More efficient query - get all crops in one query
      final cropsResponse = await _supabase.from('crop').select('*');

      if (cropsResponse == null) {
        throw Exception('Failed to fetch crops');
      }

      // Convert response to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> crops = cropsResponse is List
          ? List<Map<String, dynamic>>.from(cropsResponse.map(
              (item) => item is Map ? Map<String, dynamic>.from(item) : {}))
          : [];

      if (crops.isEmpty) {
        return [];
      }

      // Extract all crop_ids to fetch demand in one batch query
      final List<String> cropIds =
          crops.map((crop) => crop['crop_id'].toString()).toList();

      // Batch fetch all demand data for the specified week and all crops
      final demandsResponse = await _supabase
          .from('demand')
          .select('crop_id, demand')
          .eq('week_no', currentWeekNo)
          .in_('crop_id', cropIds);

      // Create a map for quick lookup of demand by crop_id
      final Map<String, double> demandByCropId = {};
      if (demandsResponse != null && demandsResponse is List) {
        for (var item in demandsResponse) {
          if (item is Map &&
              item['crop_id'] != null &&
              item['demand'] != null) {
            final cropId = item['crop_id'].toString();
            final demand = item['demand'] is num
                ? (item['demand'] is int
                    ? item['demand'].toDouble()
                    : item['demand'])
                : 0.0;
            demandByCropId[cropId] = demand;
          }
        }
      }

      // Merge crop data with demand data
      for (var i = 0; i < crops.length; i++) {
        final cropId = crops[i]['crop_id'].toString();
        crops[i]['demand'] = demandByCropId[cropId] ??
            0.0; // Use 0.0 as default if no demand found
        crops[i]['isFavorited'] = false; // Default value
      }

      // Store in cache
      _cropCache[cacheKey] = crops;

      return crops;
    } catch (e) {
      print('Error fetching crops with demand: $e');
      throw Exception('Error fetching crops: $e');
    }
  }

  // Get user's favorite crops - optimized with batched queries and caching
  Future<List<Map<String, dynamic>>> getUserFavorites({int? weekNo}) async {
    try {
      // If no week number is specified, use the current week
      final currentWeekNo = weekNo ?? _getCurrentWeekNumber();

      // Check cache first
      final cacheKey = 'week_$currentWeekNo';
      if (_favoriteCache.containsKey(cacheKey)) {
        return _favoriteCache[cacheKey]!;
      }

      // Get the current user's ID
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return [];
      }

      // Get all crops first (either from cache or fetch new)
      List<Map<String, dynamic>> allCrops;
      if (_cropCache.containsKey(cacheKey)) {
        allCrops = List.from(_cropCache[cacheKey]!);
      } else {
        allCrops = await getCropsWithDemand(weekNo: currentWeekNo);
      }

      // Efficiently get the user's favorites in a single query
      final favoritesResponse = await _supabase
          .from('favorites')
          .select('crop_id')
          .eq('user_id', userId);

      if (favoritesResponse == null ||
          (favoritesResponse is List && favoritesResponse.isEmpty)) {
        return [];
      }

      // Create a set of favorite crop IDs for efficient lookup
      final Set<String> favoriteIds = {};
      if (favoritesResponse is List) {
        for (var item in favoritesResponse) {
          if (item is Map && item['crop_id'] != null) {
            favoriteIds.add(item['crop_id'].toString());
          }
        }
      }

      // Filter all crops to get only favorites and mark them as favorited
      final List<Map<String, dynamic>> favoriteCrops = allCrops
          .where((crop) => favoriteIds.contains(crop['crop_id'].toString()))
          .map((crop) {
        final Map<String, dynamic> favCrop = Map.from(crop);
        favCrop['isFavorited'] = true;
        return favCrop;
      }).toList();

      // Store in cache
      _favoriteCache[cacheKey] = favoriteCrops;

      return favoriteCrops;
    } catch (e) {
      print('Error fetching user favorites: $e');
      throw Exception('Error fetching favorites: $e');
    }
  }

  // Get demand data for a crop across multiple weeks
  Future<Map<int, double>> getCropWeeklyDemand(
      String cropId, List<int> weekNumbers) async {
    try {
      // Check if we have this data in cache
      final cacheKey = 'crop_$cropId';
      if (_weeklyDemandCache.containsKey(cacheKey)) {
        // Check if we have all the required weeks in cache
        final cachedData = _weeklyDemandCache[cacheKey]!;
        bool hasAllWeeks = true;
        for (final weekNum in weekNumbers) {
          if (!cachedData.containsKey(weekNum)) {
            hasAllWeeks = false;
            break;
          }
        }
        if (hasAllWeeks) {
          Map<int, double> result = {};
          for (final weekNum in weekNumbers) {
            result[weekNum] = cachedData[weekNum]!;
          }
          return result;
        }
      }

      // Fetch demand data for the specified crop and weeks
      final demandsResponse = await _supabase
          .from('demand')
          .select('week_no, demand')
          .eq('crop_id', cropId)
          .in_('week_no', weekNumbers);

      // Create a map of week number to demand
      final Map<int, double> demandByWeek = {};

      // Initialize with default values (0.0) for all requested weeks
      for (final weekNum in weekNumbers) {
        demandByWeek[weekNum] = 0.0;
      }

      // Fill in actual values from the response
      if (demandsResponse != null && demandsResponse is List) {
        for (var item in demandsResponse) {
          if (item is Map &&
              item['week_no'] != null &&
              item['demand'] != null) {
            final weekNum = item['week_no'] is int
                ? item['week_no']
                : int.tryParse(item['week_no'].toString()) ?? 0;
            final demand = item['demand'] is num
                ? (item['demand'] is int
                    ? item['demand'].toDouble()
                    : item['demand'])
                : 0.0;
            demandByWeek[weekNum] = demand;
          }
        }
      }

      // Cache the results
      if (!_weeklyDemandCache.containsKey(cacheKey)) {
        _weeklyDemandCache[cacheKey] = {};
      }
      for (final entry in demandByWeek.entries) {
        _weeklyDemandCache[cacheKey]![entry.key] = entry.value;
      }

      return demandByWeek;
    } catch (e) {
      print('Error fetching crop weekly demand: $e');

      // Return empty results with 0.0 for each week
      Map<int, double> emptyResults = {};
      for (final weekNum in weekNumbers) {
        emptyResults[weekNum] = 0.0;
      }
      return emptyResults;
    }
  }

  // Check if a crop is favorited by the current user
  Future<bool> isCropFavorited(String cropId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return false;
      }

      final response = await _supabase
          .from('favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('crop_id', cropId)
          .limit(1);

      return response != null && response is List && response.isNotEmpty;
    } catch (e) {
      print('Error checking if crop is favorited: $e');
      return false;
    }
  }

  // Add a crop to favorites
  Future<bool> addFavorite(String cropId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return false;
      }

      // Check if the favorite already exists
      final exists = await isCropFavorited(cropId);
      if (exists) {
        return true; // Already a favorite, consider it a success
      }

      // Add to favorites
      await _supabase.from('favorites').insert({
        'user_id': userId,
        'crop_id': cropId,
      });

      // Clear cache to ensure fresh data on next fetch
      clearCache();

      return true;
    } catch (e) {
      print('Error adding favorite: $e');
      return false;
    }
  }

  // Remove a crop from favorites
  Future<bool> removeFavorite(String cropId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return false;
      }

      // Delete the favorite
      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('crop_id', cropId);

      // Clear cache to ensure fresh data on next fetch
      clearCache();

      return true;
    } catch (e) {
      print('Error removing favorite: $e');
      return false;
    }
  }

  // Get all categories - with caching
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      // Return cached categories if available
      if (_categoriesCache != null) {
        return _categoriesCache!;
      }

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

      // Cache the result
      _categoriesCache = result;

      return result;
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  // Clear cache for a specific week or all weeks if no week specified
  void clearCache({int? weekNo}) {
    if (weekNo != null) {
      final cacheKey = 'week_$weekNo';
      _cropCache.remove(cacheKey);
      _favoriteCache.remove(cacheKey);
    } else {
      _cropCache.clear();
      _favoriteCache.clear();
      _categoriesCache = null;
      _weeklyDemandCache.clear();
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
