import 'package:flutter/material.dart';
import '../models/crop.dart';

class CropPopup extends StatefulWidget {
  final Crop crop;

  const CropPopup({super.key, required this.crop});

  @override
  State<CropPopup> createState() => _CropPopupState();
}

class _CropPopupState extends State<CropPopup> {
  int _centerWeek = 10;

  void _shiftTimeframeLeft() {
    setState(() {
      if (_centerWeek > 8) {
        _centerWeek--;
      }
    });
  }

  void _shiftTimeframeRight() {
    setState(() {
      if (_centerWeek < 12) {
        _centerWeek++;
      }
    });
  }

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
                          widget.crop.pic,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.crop.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.crop.category,
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

            // Bar graph with dynamic week range
            SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  int week = _centerWeek - 2 + index;
                  return Column(
                    children: [
                      Container(
                        width: 40,
                        height: 100 + (week * 10),  // Dynamic height for demand
                        color: Colors.green.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text('Week $week'),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Timeframe adjustment buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _shiftTimeframeLeft,
                ),
                const Text('Adjust the timeframe.'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _shiftTimeframeRight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
