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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Favorites',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...favoriteCrops.map((crop) => CropCard(crop: crop)),
      ],
    );
  }
}