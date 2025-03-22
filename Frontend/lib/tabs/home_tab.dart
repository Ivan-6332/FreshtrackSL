import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/crop.dart';
import '../../components/greeting.dart';
import '../../components/search_bar.dart';
import '../../components/highlights.dart';
import '../../components/favorites.dart';
import '../../components/weather_widget.dart'; // New import
import '../config/app_localizations.dart';
import '../../services/database_service.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Crop> crops = [];
  List<Crop> favorites = [];
  bool isLoading = true;
  String? error;
  // Removed: bool notificationsMuted = false;

  // Calendar state variables
  late DateTime _currentWeekStart;
  late List<DateTime> _weekDays;

  // Original colors restored for main background
  final Color _primaryGreen = const Color(0xFF1B5E20); // Dark green
  final Color _darkBackground = const Color(0xFF000000); // Black background
  final Color _lightText = const Color(0xFFFFFFFF); // White text
  final Color _paleGreen = const Color(0xFFE8F5E9); // Background green
  final Color _lightBg = const Color(0xFFFAFAFA); // Off-white background

  // New gradient colors for the header card
  final Color _headerGreen = Colors.green.shade500;
  final Color _headerTeal = Colors.teal.shade400;

  // Calendar colors
  final Color _calendarBg = Colors.white;
  final Color _selectedDayBg = Colors.green.shade500;
  final Color _todayBg = Colors.greenAccent.shade100;
  final Color _dayTextColor = Colors.black87;
  final Color _selectedDayTextColor = Colors.white;
  final Color _weekdayTextColor = Colors.grey.shade700;
  final Color _navigationIconColor = Colors.green.shade700;
  final Color _resetButtonColor = Colors.green.shade500;

  @override
  void initState() {
    super.initState();
    _initializeCalendar();
    _loadData();
  }

  void _initializeCalendar() {
    // Initialize with current week
    final now = DateTime.now();
    // Find the start of the current week (Sunday or Monday depending on locale)
    _currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    if (_currentWeekStart.day > now.day) {
      // If we went to previous month, adjust
      _currentWeekStart = now.subtract(Duration(days: now.weekday + 6));
    }
    _updateWeekDays();
  }

  void _updateWeekDays() {
    _weekDays = List.generate(7, (index) =>
        _currentWeekStart.add(Duration(days: index))
    );
  }

  void _goToPreviousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
      _updateWeekDays();
    });
  }

  void _goToNextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
      _updateWeekDays();
    });
  }

  void _goToCurrentWeek() {
    setState(() {
      final now = DateTime.now();
      _currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
      if (_currentWeekStart.day > now.day) {
        _currentWeekStart = now.subtract(Duration(days: now.weekday + 6));
      }
      _updateWeekDays();
    });

    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Calendar reset to current week',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _primaryGreen,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool _isCurrentWeek() {
    final now = DateTime.now();
    final currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    if (currentWeekStart.day > now.day) {
      // If we went to previous month, adjust
      return _currentWeekStart.year == now.year &&
          _currentWeekStart.month == now.month &&
          _currentWeekStart.day == now.subtract(Duration(days: now.weekday + 6)).day;
    }
    return _currentWeekStart.year == currentWeekStart.year &&
        _currentWeekStart.month == currentWeekStart.month &&
        _currentWeekStart.day == currentWeekStart.day;
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final databaseService = DatabaseService();
      final cropsData = await databaseService.getCropsWithDemand();
      final favoritesData = await databaseService.getUserFavorites();

      setState(() {
        crops = cropsData.map((json) => Crop.fromJson(json)).toList();
        favorites = favoritesData.map((json) => Crop.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load data: $e';
        isLoading = false;
      });
    }
  }

  // Removed: void _toggleNotifications() method

  // Check if the given day is today
  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      // Restored original gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_paleGreen, _lightBg],
            stops: const [0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text(error!))
              : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card with gradient background and curved bottom border
                Container(
                  margin: EdgeInsets.only(
                    left: isSmallScreen ? 8 : 16,
                    right: isSmallScreen ? 8 : 16,
                    top: isSmallScreen ? 16 : 24,
                    bottom: 0,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_headerGreen, _headerTeal],
                      stops: const [0.3, 1.0],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  // Create a custom clipper for the curved bottom border
                  child: ClipPath(
                    clipper: CurvedBottomClipper(),
                    child: Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Greeting component with theme
                          Theme(
                            data: Theme.of(context).copyWith(
                              textTheme: Theme.of(context).textTheme.apply(
                                bodyColor: _lightText,
                                displayColor: _lightText,
                              ),
                            ),
                            child: const Greeting(),
                          ),

                          // Weather widget added below the greeting
                          Theme(
                            data: Theme.of(context).copyWith(
                              textTheme: Theme.of(context).textTheme.apply(
                                bodyColor: _lightText,
                                displayColor: _lightText,
                              ),
                            ),
                            child: const WeatherWidget(),
                          ),

                          // Add extra padding at the bottom for the curve
                          SizedBox(height: isSmallScreen ? 8 : 16),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 8 : 12),

                // Weekly Calendar section
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _calendarBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Calendar header with week range and navigation
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back button
                            IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                color: _navigationIconColor,
                                size: 28,
                              ),
                              onPressed: _goToPreviousWeek,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),

                            // Week range text with border
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${DateFormat('d MMM').format(_weekDays.first)} - ${DateFormat('d MMM').format(_weekDays.last)} ${DateFormat('yyyy').format(_weekDays.last)}',
                                style: TextStyle(
                                  color: _primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: isSmallScreen ? 13 : 14,
                                ),
                              ),
                            ),

                            // Forward button
                            IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                color: _navigationIconColor,
                                size: 28,
                              ),
                              onPressed: _goToNextWeek,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),

                      // Reset button (only visible when not on current week)
                      if (!_isCurrentWeek())
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AnimatedOpacity(
                            opacity: _isCurrentWeek() ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: ElevatedButton.icon(
                              onPressed: _goToCurrentWeek,
                              icon: const Icon(Icons.today, size: 16),
                              label: const Text('Reset to Current Week'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: _resetButtonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 8 : 12),

                // Highlights section
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: _primaryGreen,
                      colorScheme: ColorScheme.dark(
                        primary: _primaryGreen,
                        secondary: Colors.greenAccent,
                        surface: _darkBackground,
                      ),
                      textTheme: Theme.of(context).textTheme.copyWith(
                        titleMedium: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _lightText,
                          letterSpacing: 0.2,
                        ),
                        bodyMedium: TextStyle(
                          fontSize: 14,
                          color: _lightText.withOpacity(0.8),
                        ),
                      ),
                    ),
                    child: Highlights(crops: crops),
                  ),
                ),

                // Favorites section
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 32),
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: _primaryGreen,
                      colorScheme: ColorScheme.dark(
                        primary: _primaryGreen,
                        secondary: Colors.greenAccent,
                        surface: _darkBackground,
                      ),
                      textTheme: Theme.of(context).textTheme.copyWith(
                        titleMedium: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _lightText,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    child: FavoritesWithHeartIcons(crops: favorites),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced wrapper for Favorites to add animated heart icons
class FavoritesWithHeartIcons extends StatelessWidget {
  final List<Crop> crops;

  const FavoritesWithHeartIcons({
    super.key,
    required this.crops,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // This component delivers the Favorites component with enhanced styling
        return Favorites(crops: crops);
      },
    );
  }
}

// Custom clipper for curved bottom border
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Create a path
    Path path = Path();

    // Start from top left
    path.lineTo(0, size.height - 20);

    // Create a smoother curve that matches the image
    path.quadraticBezierTo(
      size.width / 2, // control point x (middle of width)
      size.height + 15, // control point y (below the bottom for deeper curve)
      size.width, // end point x (right side)
      size.height - 20, // end point y
    );

    // Line to top right
    path.lineTo(size.width, 0);

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}