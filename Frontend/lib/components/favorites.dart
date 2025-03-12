import 'package:flutter/material.dart';
import '../models/crop.dart';
import 'crop_card.dart';
import '../config/app_localizations.dart';

class Favorites extends StatelessWidget {
  final List<Crop> crops;

  const Favorites({super.key, required this.crops});

  @override
  Widget build(BuildContext context) {
    final favoriteCrops = crops.where((crop) => crop.isFavorited).toList();
    final localizations = AppLocalizations.of(context);

    return Container(
      // Light green gradient background matching Highlights
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade50.withOpacity(0.8),
            Colors.green.shade100.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unified header with combined background for icon and text - updated to match Highlights
          Padding(
            padding: const EdgeInsets.only(bottom: 36), // Increased bottom padding to match Highlights
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade50.withOpacity(0.5), // Lighter background to match Highlights
                    Colors.green.shade100.withOpacity(0.3), // Lighter background to match Highlights
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.15), // Matching Highlights shadow
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                    spreadRadius: 1,
                  ),
                ],
                border: Border.all(
                  color: Colors.green.shade200.withOpacity(0.9), // Matching Highlights border
                  width: 1.8,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16), // Matching Highlights padding
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon in the same container as text - increased size to match Highlights
                    Icon(
                      Icons.favorite,
                      color: Colors.green.shade700,
                      size: 36, // Increased from 32 to match Highlights
                    ),

                    const SizedBox(width: 16),

                    // Text section - updated to match Highlights
                    Text(
                      localizations.get('favorites'),
                      style: TextStyle(
                        fontSize: 32, // Increased from 28 to match Highlights
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: 0.2,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.green.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Favorite crop cards with styling matching Highlights
          ...favoriteCrops.asMap().entries.map((entry) {
            final index = entry.key;
            final crop = entry.value;
            final isLast = index == favoriteCrops.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Transform.scale(
                scale: 1.05,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CropCard(crop: crop),
                ),
              ),
            );
          }).toList(),

          // Extra space after the component
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}