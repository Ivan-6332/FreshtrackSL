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
  bool _isFavorite = false;

  final Map<int, double> _weeklyDemandData = {
    8: 65.0,
    9: 55.0,
    10: 85.0,
    11: 60.0,
    12: 75.0,
  };

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

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
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

            // Bar graph with dynamic demand data
            SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  int week = _centerWeek - 2 + index;
                  double demand = _weeklyDemandData[week] ?? 50.0;
                  return Column(
                    children: [
                      Container(
                        width: 40,
                        height: 100 * (demand / 100),
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

            const SizedBox(height: 20),

            // Favorite button
            GestureDetector(
              onTap: _toggleFavorite,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Add to Favourites',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
