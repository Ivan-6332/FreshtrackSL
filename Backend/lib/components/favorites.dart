// lib/components/favorites.dart
import 'package:flutter/material.dart';
import '../models/crop.dart';
import 'crop_card.dart';

class Favorites extends StatelessWidget {
  final List<Crop> crops;

  const Favorites({super.key, required this.crops});

  @override
  Widget build(BuildContext context) {
    final favoriteCrops = crops.where((crop) => crop.isFavorited).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.green.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.green.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ), //text
              ],
            ),
          ),
          ...favoriteCrops.map((crop) => CropCard(crop: crop)), //
        ],
      ),
    );
  }
}
