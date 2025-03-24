// lib/screens/tabs/explore_tab.dart
import 'package:flutter/material.dart';
import '../../models/crop.dart';
import '../../components/search_bar.dart';
import '../../components/crop_card.dart';
import '../../components/category_grid.dart';
import '../config/app_localizations.dart';
import '../../services/database_service.dart';
import 'package:provider/provider.dart';
import '../../providers/week_provider.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab>
    with AutomaticKeepAliveClientMixin {
  String? selectedCategory;
  List<Crop> crops = [];
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;
  bool isInitialLoad = true;
  String? error;
  final DatabaseService _databaseService = DatabaseService();

  @override
  bool get wantKeepAlive => true;

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

  int? _previousWeekNumber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final weekProvider = Provider.of<WeekProvider>(context);
    if (_previousWeekNumber != weekProvider.selectedWeek) {
      _previousWeekNumber = weekProvider.selectedWeek;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    // Set loading to true, but don't show loading indicator for subsequent loads
    setState(() {
      if (isInitialLoad) {
        isLoading = true;
      }
      error = null;
    });

    try {
      // Get the selected week from the provider
      final weekProvider = Provider.of<WeekProvider>(context, listen: false);
      final selectedWeek = weekProvider.selectedWeek;

      // Use efficient batch queries
      final cropsData =
          await _databaseService.getCropsWithDemand(weekNo: selectedWeek);
      final categoriesData = await _databaseService.getCategories();

      if (!mounted) return;

      setState(() {
        crops = cropsData.map((json) => Crop.fromJson(json)).toList();
        categories = categoriesData;
        isLoading = false;
        isInitialLoad = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Failed to load data: $e';
        isLoading = false;
        isInitialLoad = false;
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
    super.build(context); // Required for AutomaticKeepAliveClientMixin

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
        child: isLoading && isInitialLoad
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red[700], size: 48),
                        const SizedBox(height: 16),
                        Text(
                          error!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadData,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: _primaryGreen,
                          ),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      // Clear cache for current week and reload
                      final weekProvider =
                          Provider.of<WeekProvider>(context, listen: false);
                      _databaseService.clearCache(
                          weekNo: weekProvider.selectedWeek);
                      await _loadData();
                    },
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const SizedBox(height: 24),

                              // Explore title with enhanced styling
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(16, 16, 0, 0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 0),

                                  child: Text(
                                    'Explore & Find All Crops Here!',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800,
                                      color: _darkText,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(16, 16, 24, 0),
                                  child: Container(
                                    child: Text(
                                      'Use either the search bar or the categories listed below to filter & find the crops you need.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: _darkText,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                              ),

                              const SizedBox(height: 16),

                              // Search bar without background container
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: _accentGreen.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              _primaryGreen.withOpacity(0.08),
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

                              // Display message when no crops in category
                              if (selectedCategory != null &&
                                  filteredCrops.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(Icons.eco_outlined,
                                            size: 64,
                                            color:
                                                _primaryGreen.withOpacity(0.6)),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No crops found in this category',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: _darkText,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedCategory = null;
                                            });
                                          },
                                          child: Text(
                                            'View all crops',
                                            style: TextStyle(
                                              color: _primaryGreen,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              // Wrap crop cards in enhanced containers
                              ...filteredCrops.map((crop) => Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                _primaryGreen.withOpacity(0.1),
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
                        if (isLoading && !isInitialLoad)
                          Positioned(
                            top: 100,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Text(
                                      'Updating data...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
