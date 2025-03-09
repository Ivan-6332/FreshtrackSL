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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with combined background for icon and text
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon section
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.green.shade700,
                    size: 27,
                  ),
                ),

                // Text section
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 12, top: 6, bottom: 6),
                  child: Text(
                    localizations.get('favorites'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Favorite crop cards with enhanced elevation
        ...favoriteCrops.asMap().entries.map((entry) {
          final index = entry.key;
          final crop = entry.value;
          final isLast = index == favoriteCrops.length - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
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
          );
        }).toList(),
      ],
    );
  }
}