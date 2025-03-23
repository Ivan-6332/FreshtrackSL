import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/crop.dart';
import '../../components/greeting.dart';
import '../../components/search_bar.dart';
import '../../components/highlights.dart';
import '../../components/favorites.dart';
import '../../components/weather_widget.dart';
import '../../components/calendar.dart';
import '../config/app_localizations.dart';
import '../../services/database_service.dart';
import 'package:provider/provider.dart';
import '../../providers/week_provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  List<Crop> crops = [];
  List<Crop> favorites = [];
  bool isLoading = true;
  bool isInitialLoad = true;
  String? error;
  final DatabaseService _databaseService = DatabaseService();

  @override
  bool get wantKeepAlive => true;

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
    if (!mounted) return;

    // Set loading to true, but don't show loading indicator for subsequent loads
    setState(() {
      if (isInitialLoad) {
        isLoading = true;
      }
      error = null;
    });

    try {
      // Get the selected week from the provider
      final weekProvider = Provider.of<WeekProvider>(context, listen: false);
      final selectedWeek = weekProvider.selectedWeek;

      // Use batch queries from the optimized database service
      final cropsData =
      await _databaseService.getCropsWithDemand(weekNo: selectedWeek);
      final favoritesData =
      await _databaseService.getUserFavorites(weekNo: selectedWeek);

      if (!mounted) return;

      setState(() {
        crops = cropsData.map((json) => Crop.fromJson(json)).toList();
        favorites = favoritesData.map((json) => Crop.fromJson(json)).toList();
        isLoading = false;
        isInitialLoad = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Failed to load data: $e';
        isLoading = false;
        isInitialLoad = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

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
          child: isLoading && isInitialLoad
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    color: Colors.red[700], size: 48),
                const SizedBox(height: 16),
                Text(
                  error!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loadData,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _primaryGreen,
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          )
              : RefreshIndicator(
            onRefresh: () async {
              // Clear cache for the current week
              final weekProvider =
              Provider.of<WeekProvider>(context, listen: false);
              _databaseService.clearCache(
                  weekNo: weekProvider.selectedWeek);
              await _loadData();
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting component - now separated
                      Container(
                        margin: EdgeInsets.only(
                          left: isSmallScreen ? 8 : 2,
                          right: isSmallScreen ? 8 : 16,
                          top: isSmallScreen ? 16 : 24,
                          bottom: 0,
                        ),
                        decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          //   colors: [_headerGreen, _headerTeal],
                          //   stops: const [0.3, 1.0],
                          // ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            // BoxShadow(
                            //   color: Colors.black.withOpacity(0.1),
                            //   spreadRadius: 1,
                            //   blurRadius: 6,
                            //   offset: const Offset(0, 3),
                            // ),
                          ],
                        ),
                        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: Theme.of(context)
                                .textTheme
                                .apply(
                              bodyColor: _lightText,
                              displayColor: _lightText,
                            ),
                          ),
                          child: const Greeting(),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 8 : 12),

                      // Weather widget - now separate from greeting
                      Container(
                        margin: EdgeInsets.only(
                          left: isSmallScreen ? 8 : 16,
                          right: isSmallScreen ? 8 : 16,
                          bottom: 0,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [_headerGreen, _headerTeal],
                            stops: const [0.3, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: Theme.of(context)
                                .textTheme
                                .apply(
                              bodyColor: _lightText,
                              displayColor: _lightText,
                            ),
                          ),
                          child: const WeatherWidget(),
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
                        margin:
                        const EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                            textTheme: Theme.of(context)
                                .textTheme
                                .copyWith(
                              titleMedium: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _lightText,
                                letterSpacing: 0.2,
                              ),
                              bodyMedium: TextStyle(
                                fontSize: 14,
                                color:
                                _lightText.withOpacity(0.8),
                              ),
                            ),
                          ),
                          child: Highlights(crops: crops),
                        ),
                      ),

                      // Favorites section
                      Container(
                        margin:
                        const EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                            textTheme:
                            Theme.of(context).textTheme.copyWith(
                              titleMedium: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _lightText,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          child: FavoritesWithHeartIcons(
                              crops: favorites),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading && !isInitialLoad)
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Updating data...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
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

// Custom clipper for curved bottom border (kept for reference but no longer used)
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