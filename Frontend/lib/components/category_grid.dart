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

    // More granular responsive sizing based on different screen widths
    final double iconSize = _getResponsiveIconSize(screenWidth);
    final double fontSize = _getResponsiveFontSize(screenWidth);
    final double containerSize = _getResponsiveContainerSize(screenWidth);

    // Calculate appropriate grid count based on screen width
    final int crossAxisCount = _getResponsiveCrossAxisCount(screenWidth);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        // Dynamic childAspectRatio based on screen size
        childAspectRatio: screenWidth < 400 ? 0.9 : 1.0,
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
                  width: containerSize,
                  height: containerSize,
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
                  child: Center(
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
                        textAlign: TextAlign.center,
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
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper methods for responsive sizing
  double _getResponsiveIconSize(double screenWidth) {
    if (screenWidth < 320) return 22;
    if (screenWidth < 360) return 24;
    if (screenWidth < 480) return 28;
    if (screenWidth < 600) return 30;
    return 32; // For tablets and larger screens
  }

  double _getResponsiveFontSize(double screenWidth) {
    if (screenWidth < 320) return 11;
    if (screenWidth < 360) return 12;
    if (screenWidth < 480) return 14;
    if (screenWidth < 600) return 15;
    return 16; // For tablets and larger screens
  }

  // New method to calculate container size
  double _getResponsiveContainerSize(double screenWidth) {
    if (screenWidth < 320) return 48;
    if (screenWidth < 360) return 56;
    if (screenWidth < 480) return 64;
    if (screenWidth < 600) return 72;
    return 80; // For tablets and larger screens
  }

  int _getResponsiveCrossAxisCount(double screenWidth) {
    if (screenWidth < 320) return 3;
    if (screenWidth < 600) return 4;
    if (screenWidth < 900) return 5;
    return 6; // For very large screens
  }
}