// lib/components/category_grid.dart
import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final Function(String) onCategorySelected;
  final String? selectedCategory;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category['name'] == selectedCategory;

        return GestureDetector(
          onTap: () => onCategorySelected(category['name']),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(12),
                child: Text(
                  category['icon'],
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category['name'].split(' ')[0],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
