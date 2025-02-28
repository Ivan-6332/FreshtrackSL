// lib/screens/tabs/explore_tab.dart
import 'package:flutter/material.dart';
import '../../models/crop.dart';
import '../../components/search_bar.dart';
import '../../components/crop_card.dart';
import '../../components/category_grid.dart';
import '../../data/app_data.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  String? selectedCategory;
  List<Crop> crops = [];

  @override
  void initState() {
    super.initState();
    _loadCrops();
  }

  void _loadCrops() {
    setState(() {
      crops = AppData.vegetables.map((json) => Crop.fromJson(json)).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = selectedCategory == category ? null : category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredCrops = selectedCategory != null
        ? crops.where((crop) => crop.category == selectedCategory).toList()
        : crops;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          const SearchBarWithProfile(),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Explore',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CategoryGrid(
              categories: AppData.categories,
              onCategorySelected: _onCategorySelected,
              selectedCategory: selectedCategory,
            ),
          ),
          if (selectedCategory != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                selectedCategory!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          ...filteredCrops.map((crop) => CropCard(crop: crop)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
