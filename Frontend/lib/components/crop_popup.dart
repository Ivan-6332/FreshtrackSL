import 'package:flutter/material.dart';
import '../models/crop.dart';

class CropPopup extends StatelessWidget {
  final Crop crop;

  const CropPopup({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with crop name and category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          crop.pic,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          crop.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          crop.category,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Basic bar graph (static data)
            SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 100,
                        color: Colors.green.shade400,
                      ),
                      const SizedBox(height: 8),
                      const Text('Week 8'),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 120,
                        color: Colors.green.shade400,
                      ),
                      const SizedBox(height: 8),
                      const Text('Week 9'),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 80,
                        color: Colors.green.shade400,
                      ),
                      const SizedBox(height: 8),
                      const Text('Week 10'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
