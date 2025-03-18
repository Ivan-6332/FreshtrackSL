import 'package:flutter/material.dart';
import '../../models/crop.dart';
import '../../components/greeting.dart';
import '../../components/search_bar.dart';
import '../../components/highlights.dart';
import '../../components/favorites.dart';
import '../config/app_localizations.dart';
import '../../services/database_service.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Crop> crops = [];
  List<Crop> favorites = [];
  bool isLoading = true;
  String? error;

  // Basic color palette
  final Color _primaryGreen = const Color(0xFF1B5E20); // Dark green
  final Color _lightText = const Color(0xFFFFFFFF); // White text

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final databaseService = DatabaseService();
      final cropsData = await databaseService.getCropsWithDemand();
      final favoritesData = await databaseService.getUserFavorites();

      setState(() {
        crops = cropsData.map((json) => Crop.fromJson(json)).toList();
        favorites = favoritesData.map((json) => Crop.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Solid black background instead of gradient
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text(error!))
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header section with basic styling
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Greeting with white text
                              Text(
                                AppLocalizations.of(context)!.helloUser,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _lightText,
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Search bar with basic styling
                              TextField(
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!.searchHint,
                                  hintStyle: TextStyle(color: _lightText.withOpacity(0.6)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: _primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Highlights section with basic styling
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Highlights(crops: crops),
                        ),

                        const SizedBox(height: 16),

                        // Favorites section with basic styling
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Favorites(crops: favorites),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}