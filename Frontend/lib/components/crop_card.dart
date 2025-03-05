// lib/components/crop_card.dart
import 'package:flutter/material.dart';
import '../models/crop.dart';

class CropCard extends StatelessWidget {
  final Crop crop;

  const CropCard({super.key, required this.crop});

  String getCropIcon() {
    switch (crop.name.toLowerCase()) {
      case 'carrot':
        return '🥕';
      case 'tomato':
        return '🍅';
      case 'beans':
        return '🫘';
      case 'cabbage':
        return '🥬';
      case 'onion':
        return '🧅';
      default:
        return '🌱';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon and Name section
                Text(
                  getCropIcon(),
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    crop.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: crop.demand > 150 ? Colors.green[100] : Colors.red[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${crop.demand.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: crop.demand > 150 ? Colors.green[900] : Colors.red[900],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Button section
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View History',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}