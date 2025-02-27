// lib/components/highlights.dart
import 'package:flutter/material.dart';
import '../models/crop.dart';
import 'crop_card.dart';

class Highlights extends StatelessWidget {
  final List<Crop> crops;

  const Highlights({super.key, required this.crops});

  @override
  Widget build(BuildContext context) {
    final sortedCrops = List<Crop>.from(crops)
      ..sort((a, b) => b.demand.compareTo(a.demand));

    final highestDemand = sortedCrops.first;
    final lowestDemand = sortedCrops.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Highlights',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CropCard(crop: highestDemand),
        CropCard(crop: lowestDemand),
      ],
    );
  }
}