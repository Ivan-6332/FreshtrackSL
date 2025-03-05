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
//container
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
            ), //child
            child: Row(
              children: [
                Icon(Icons.trending_up, color: Colors.green.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Highlights',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          CropCard(crop: highestDemand),
          CropCard(crop: lowestDemand),
        ],
      ),
    );
  }
}
