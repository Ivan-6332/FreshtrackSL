// lib/components/crop_card.dart
import 'package:flutter/material.dart';
import '../models/crop.dart';

class CropCard extends StatelessWidget {
  final Crop crop;

  const CropCard({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                crop.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('View History'),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: crop.demand > 150 ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${crop.demand.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: crop.demand > 150 ? Colors.green[900] : Colors.red[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}