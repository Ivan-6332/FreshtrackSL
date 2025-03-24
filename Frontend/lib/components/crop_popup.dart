import 'package:flutter/material.dart';
import '../models/crop.dart';
import '../services/database_service.dart';
import 'package:provider/provider.dart';
import '../providers/week_provider.dart';

class CropPopup extends StatefulWidget {
  final Crop crop;

  const CropPopup({super.key, required this.crop});

  @override
  State<CropPopup> createState() => _CropPopupState();
}

class _CropPopupState extends State<CropPopup> {
  int _centerWeekNumber = 12; // Default center week
  bool _isFavorite = false;
  bool _isLoading = false;
  bool _isLoadingDemandData = false;
  final DatabaseService _databaseService = DatabaseService();
  Map<int, double> _weeklyDemandData = {};

  @override
  void initState() {
    super.initState();
    // Initialize with the crop's favorited status
    _isFavorite = widget.crop.isFavorited;
    // Double-check with the database
    _checkFavoriteStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the current week from the provider
    final weekProvider = Provider.of<WeekProvider>(context, listen: false);
    _centerWeekNumber = weekProvider.selectedWeek;

    // Fetch demand data for the visible weeks
    _fetchWeeklyDemandData();
  }

  Future<void> _checkFavoriteStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final isFavorited =
          await _databaseService.isCropFavorited(widget.crop.id);
      setState(() {
        _isFavorite = isFavorited;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error checking favorite status: $e');
    }
  }

  Future<void> _fetchWeeklyDemandData() async {
    setState(() {
      _isLoadingDemandData = true;
    });

    try {
      // Get the weeks to display
      final visibleWeeks = _getVisibleWeeks();

      // Fetch demand data for these weeks
      final demandData = await _databaseService.getCropWeeklyDemand(
          widget.crop.id, visibleWeeks);

      if (mounted) {
        setState(() {
          _weeklyDemandData = demandData;
          _isLoadingDemandData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDemandData = false;
        });
      }
      print('Error fetching weekly demand data: $e');
    }
  }

  void _shiftTimeframeLeft() {
    setState(() {
      if (_centerWeekNumber > 10) {
        // Prevent going too far back
        _centerWeekNumber--;
      }
    });
    _fetchWeeklyDemandData();
  }

  void _shiftTimeframeRight() {
    setState(() {
      if (_centerWeekNumber < 14) {
        // Prevent going too far forward
        _centerWeekNumber++;
      }
    });
    _fetchWeeklyDemandData();
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool success;
      if (_isFavorite) {
        // Remove from favorites
        success = await _databaseService.removeFavorite(widget.crop.id);
      } else {
        // Add to favorites
        success = await _databaseService.addFavorite(widget.crop.id);
      }

      if (success) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<int> _getVisibleWeeks() {
    // Return 5 weeks centered around the current week
    return [
      _centerWeekNumber - 2,
      _centerWeekNumber - 1,
      _centerWeekNumber,
      _centerWeekNumber + 1,
      _centerWeekNumber + 2,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final visibleWeeks = _getVisibleWeeks();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with crop name, category and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10.0, top: 10.0),
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
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          widget.crop.category,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.red.shade900,
                  iconSize: 35.0,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Bar graph
            SizedBox(
              height: 200,
              child: _isLoadingDemandData
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green.shade400),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: visibleWeeks.map((weekNum) {
                        final demand = _weeklyDemandData[weekNum] ?? 0.0;
                        final isCurrentWeek = weekNum ==
                            Provider.of<WeekProvider>(context, listen: false)
                                .selectedWeek;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Bar
                            Container(
                              width: 40,
                              height: 180 * (demand / 100), // Scale height based on demand (max at 200%)
                              decoration: BoxDecoration(
                                color: isCurrentWeek
                                    ? Colors.green.shade700
                                    : Colors.green.shade400,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${demand.toDouble()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            // Week number
                            const SizedBox(height: 8),
                            Text(
                              '$weekNum',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: isCurrentWeek
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
            ),

            const SizedBox(height: 10),

            // Week label
            const Text(
              'Week No.',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Timeframe adjustment button
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _shiftTimeframeLeft,
                  ),
                  const Text(
                    'Adjust the timeframe',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _shiftTimeframeRight,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Favorite button
            GestureDetector(
              onTap: _isLoading ? null : _toggleFavorite,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        _isFavorite
                            ? 'Remove from Favourites'
                            : 'Add to Favourites',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _isFavorite ? Colors.red : Colors.grey,
                                ),
                              ),
                            )
                          : Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
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
