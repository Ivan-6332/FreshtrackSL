// lib/screens/tabs/explore_tab.dart
import 'package:flutter/material.dart';
import '../../models/crop.dart';
import '../../components/search_bar.dart';
import '../../components/crop_card.dart';
import '../../components/category_grid.dart';
import '../config/app_localizations.dart';
import '../../services/database_service.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  String? selectedCategory;
  List<Crop> crops = [];
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;
  String? error;

  // Basic color palette
  final Color _primaryGreen = const Color(0xFF4CAF50); // Main green
  final Color _darkText = const Color(0xFF212121); // Near black for text

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
      final categoriesData = await databaseService.getCategories();

      setState(() {
        crops = cropsData.map((json) => Crop.fromJson(json)).toList();
        categories = categoriesData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load data: $e';
        isLoading = false;
      });
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = selectedCategory == category ? null : category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final filteredCrops = selectedCategory != null
        ? crops.where((crop) => crop.category == selectedCategory).toList()
        : crops;

    return Scaffold(
      backgroundColor: Colors.white,
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
                        // Search bar with basic styling
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: localizations?.searchHint ?? 'Search...',
                              hintStyle: TextStyle(color: _darkText.withOpacity(0.6)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: _primaryGreen.withOpacity(0.1),
                            ),
                          ),
                        ),

                        // Explore title with basic styling
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: _darkText,
                            ),
                          ),
                        ),

                        // Category grid with basic styling
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: CategoryGrid(
                            categories: categories,
                            onCategorySelected: _onCategorySelected,
                            selectedCategory: selectedCategory,
                          ),
                        ),

                        // Selected category title with basic styling
                        if (selectedCategory != null) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              selectedCategory!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _primaryGreen,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Crop cards with basic styling
                        ...filteredCrops.map((crop) => Padding(
                              padding: const EdgeInsets.all(8),
                              child: CropCard(crop: crop),
                            )),
                      ],
                    ),
                  ),
      ),
    );
  }
}