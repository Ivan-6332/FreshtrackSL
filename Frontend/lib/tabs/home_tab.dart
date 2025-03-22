import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/crop.dart';
import '../../components/greeting.dart';
import '../../components/search_bar.dart';
import '../../components/highlights.dart';
import '../../components/favorites.dart';
import '../../components/weather_widget.dart'; // New import
import '../../components/calendar.dart'; // New calendar component import
import '../config/app_localizations.dart';
import '../../services/database_service.dart';
import 'package:provider/provider.dart';
import '../../providers/week_provider.dart';

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

  // Original colors restored for main background
  final Color _primaryGreen = const Color(0xFF1B5E20); // Dark green
  final Color _darkBackground = const Color(0xFF000000); // Black background
  final Color _lightText = const Color(0xFFFFFFFF); // White text
  final Color _paleGreen = const Color(0xFFE8F5E9); // Background green
  final Color _lightBg = const Color(0xFFFAFAFA); // Off-white background

  // New gradient colors for the header card
  final Color _headerGreen = Colors.green.shade500;
  final Color _headerTeal = Colors.teal.shade400;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  int? _previousWeekNumber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final weekProvider = Provider.of<WeekProvider>(context);
    if (_previousWeekNumber != weekProvider.selectedWeek) {
      _previousWeekNumber = weekProvider.selectedWeek;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Get the selected week from the provider
      final weekProvider = Provider.of<WeekProvider>(context, listen: false);
      final selectedWeek = weekProvider.selectedWeek;

      final databaseService = DatabaseService();
      final cropsData =
          await databaseService.getCropsWithDemand(weekNo: selectedWeek);
      final favoritesData =
          await databaseService.getUserFavorites(weekNo: selectedWeek);

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
                                padding:
                                    EdgeInsets.all(isSmallScreen ? 12 : 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Greeting component with theme
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        textTheme:
                                            Theme.of(context).textTheme.apply(
                                                  bodyColor: _lightText,
                                                  displayColor: _lightText,
                                                ),
                                      ),
                                      child: const Greeting(),
                                    ),

                                    // Weather widget added below the greeting
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        textTheme:
                                            Theme.of(context).textTheme.apply(
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

                          // Weekly Calendar section - now using the Calendar component
                          Calendar(
                            margin: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 16,
                              vertical: 8,
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
