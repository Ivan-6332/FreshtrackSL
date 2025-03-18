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

  // Enhanced color palette - matching with HomeTab
  final Color _primaryGreen = const Color(0xFF4CAF50); // Main green
  final Color _accentGreen = const Color(0xFF81C784); // Secondary green
  final Color _paleGreen = const Color(0xFFE8F5E9); // Background green
  final Color _darkText = const Color(0xFF212121); // Near black for text
  final Color _lightBg = const Color(0xFFFAFAFA); // Off-white background

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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_paleGreen, _lightBg],
          stops: const [0.3, 1.0],
        ),
      ),
      child: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text(error!))
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar without background container
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              primaryColor: _primaryGreen,
                              hintColor: _darkText.withOpacity(0.4),
                              colorScheme: ColorScheme.light(
                                primary: _primaryGreen,
                                surface: Colors.transparent,
                              ),
                            ),
                            child: const SearchBarWithProfile(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Explore title with enhanced styling
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryGreen.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Explore',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _darkText,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),

                        // Category grid with enhanced styling
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryGreen.withOpacity(0.12),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: CategoryGrid(
                              categories: categories,
                              onCategorySelected: _onCategorySelected,
                              selectedCategory: selectedCategory,
                            ),
                          ),
                        ),

                        // Selected category title with matching style
                        if (selectedCategory != null) ...[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: _accentGreen.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: _primaryGreen.withOpacity(0.08),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                selectedCategory!,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _primaryGreen,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Wrap crop cards in enhanced containers
                        ...filteredCrops.map((crop) => Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _primaryGreen.withOpacity(0.1),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CropCard(crop: crop),
                                ),
                              ),
                            )),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
      ),
    );
  }
}
