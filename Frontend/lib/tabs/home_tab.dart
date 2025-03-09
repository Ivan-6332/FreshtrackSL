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
  final Color _primaryGreen = const Color(0xFF4CAF50); // Main green
  final Color _accentGreen = const Color(0xFF81C784); // Secondary green
  final Color _paleGreen = const Color(0xFFE8F5E9); // Background green
  final Color _darkText = const Color(0xFF212121); // Near black for text
  final Color _lightBg = const Color(0xFFFAFAFA); // Off-white background
  final Color _cardBg = const Color(0xFFF5F5F5); // Subtle card background

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
      // Apply gradient to the entire scaffold background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_lightBg, _lightBg],
            stops: const [0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced header section with floating effect
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting with enhanced styling
                      Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: Theme.of(context).textTheme.apply(
                            bodyColor: _darkText,
                            displayColor: _primaryGreen,
                          ),
                        ),
                        child: const Greeting(),
                      ),

                      const SizedBox(height: 24),

                      // Modernized search bar with frosted glass effect
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white.withOpacity(0.7),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryGreen.withOpacity(0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: _primaryGreen,
                            hintColor: _darkText.withOpacity(0.4),
                            colorScheme: ColorScheme.light(
                              primary: _primaryGreen,
                              surface: Colors.white,
                            ),
                          ),
                          child: const SearchBarWithProfile(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Highlights section with frosted glass effect
                Container(
                  margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.7),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryGreen.withOpacity(0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 1,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: _primaryGreen,
                      colorScheme: ColorScheme.light(
                        primary: _primaryGreen,
                        secondary: _accentGreen,
                        surface: Colors.white,
                      ),
                      elevatedButtonTheme: ElevatedButtonThemeData(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: _primaryGreen,
                          elevation: 5,
                          shadowColor: _primaryGreen.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                        ),
                      ),
                      textTheme: Theme.of(context).textTheme.copyWith(
                        titleMedium: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _darkText,
                          letterSpacing: 0.2,
                        ),
                        bodyMedium: TextStyle(
                          fontSize: 14,
                          color: _darkText.withOpacity(0.8),
                        ),
                      ),
                      cardTheme: CardTheme(
                        color: _cardBg.withOpacity(0.7),
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: _primaryGreen.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    child: Highlights(crops: crops),
                  ),
                ),

                // Favorites section with frosted glass effect and animated heart icons
                Container(
                  margin: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.7),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryGreen.withOpacity(0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 1,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: _primaryGreen,
                      colorScheme: ColorScheme.light(
                        primary: _primaryGreen,
                        secondary: _accentGreen,
                        surface: Colors.white,
                      ),
                      textTheme: Theme.of(context).textTheme.copyWith(
                        titleMedium: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _darkText,
                          letterSpacing: 0.2,
                        ),
                      ),
                      elevatedButtonTheme: ElevatedButtonThemeData(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: _primaryGreen,
                          elevation: 5,
                          shadowColor: _primaryGreen.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                        ),
                      ),
                      cardTheme: CardTheme(
                        color: _cardBg.withOpacity(0.7),
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: _primaryGreen.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      iconTheme: IconThemeData(
                        color: Colors.redAccent,
                        size: 22,
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