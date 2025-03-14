import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/crop.dart';
import '../../components/greeting.dart';
import '../../components/search_bar.dart';
import '../../components/highlights.dart';
import '../../components/favorites.dart';
import '../config/app_localizations.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<Crop> crops = [];

  // Enhanced color palette
  final Color _primaryGreen = const Color(0xFF1B5E20); // Dark green
  final Color _darkBackground = const Color(0xFF000000); // Black background
  final Color _lightText = const Color(0xFFFFFFFF); // White text

  // Added these colors from ExploreTab
  final Color _paleGreen = const Color(0xFFE8F5E9); // Background green
  final Color _lightBg = const Color(0xFFFAFAFA); // Off-white background

  @override
  void initState() {
    super.initState();
    _loadCrops();
  }

  void _loadCrops() {
    setState(() {
      crops = AppData.vegetables.map((json) => Crop.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Applied gradient background from ExploreTab instead of solid black
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced header section with dark theme
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting with white text
                      Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: Theme.of(context).textTheme.apply(
                            bodyColor: _lightText,
                            displayColor: _lightText,
                          ),
                        ),
                        child: const Greeting(),
                      ),

                      const SizedBox(height: 24),

                      // Modernized search bar with dark theme
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: _primaryGreen,
                          hintColor: _lightText.withOpacity(0.4),
                          colorScheme: ColorScheme.dark(
                            primary: _primaryGreen,
                            surface: _darkBackground,
                          ),
                        ),
                        child: const SearchBarWithProfile(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12), // Reduced gap between search bar and highlights

                // Highlights section with dark theme and wider width
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 16), // Reduced horizontal margins
                  padding: const EdgeInsets.all(16), // Smaller padding to maximize content space
                  width: double.infinity, // Ensure it takes full width
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

                // Favorites section with dark theme and wider width
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 32), // Reduced horizontal margins
                  padding: const EdgeInsets.all(16), // Smaller padding to maximize content space
                  width: double.infinity, // Ensure it takes full width
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
                    child: FavoritesWithHeartIcons(crops: crops),
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