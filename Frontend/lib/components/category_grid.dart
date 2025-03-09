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
    // Get screen size to make icons responsive
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate appropriate sizes based on screen width
    final double iconSize = screenWidth < 360 ? 20 : 24;
    final double fontSize = screenWidth < 360 ? 10 : 12;
    final double padding = screenWidth < 360 ? 8 : 12;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        // Add childAspectRatio to control the height of grid items
        childAspectRatio: screenWidth < 360 ? 0.9 : 1.0,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category['name'] == selectedCategory;

        return GestureDetector(
          onTap: () => onCategorySelected(category['name']),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use minimum space needed
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 5,
                        offset: const Offset(-1, -1),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(padding),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(0.1)
                      ..rotateY(-0.1),
                    alignment: Alignment.center,
                    child: Text(
                      category['icon'],
                      style: TextStyle(
                        fontSize: iconSize,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2), // Reduced spacing
              Padding(
                padding: const EdgeInsets.only(bottom: 2), // Add bottom padding
                child: Text(
                  category['name'].split(' ')[0],
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}