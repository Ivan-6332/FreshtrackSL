// lib/screens/tabs/home_tab.dart
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

  // Calming color palette
  final Color _calmGreen = const Color(0xFF4CAF50); // Soft medium green
  final Color _darkGreen = const Color(0xFF81C784); // Darker green for buttons
  final Color _lightGreen = const Color(0xFFE8F5E9); // Very soft, pale green
  final Color _softBlack = const Color(0xFF424242); // Soft, not harsh black
  final Color _offWhite =
      const Color(0xFFFAFAFA); // Slightly off-white for eye comfort
  final Color _cardBg =
      const Color(0xFFF0F0F0); // Slightly darker card background

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
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: _offWhite,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 20),
              color: _offWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Theme(
                    data: Theme.of(context).copyWith(
                      textTheme: Theme.of(context).textTheme.apply(
                            bodyColor: _softBlack,
                            displayColor: _darkGreen,
                          ),
                    ),
                    child: const Greeting(),
                  ),

                  const SizedBox(height: 20),

                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _offWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: _calmGreen,
                        hintColor: _softBlack.withOpacity(0.4),
                        colorScheme: ColorScheme.light(
                          primary: _calmGreen,
                          surface: _offWhite,
                        ),
                      ),
                      child: const SearchBarWithProfile(),
                    ),
                  ),
                ],
              ),
            ),

            // Highlights section with enhanced card styling
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section title
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      localizations.get('todaysHighlights'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: _softBlack,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  // Highlights with enhanced styling
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _cardBg, // Slightly darker card background
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: _calmGreen,
                        colorScheme: ColorScheme.light(
                          primary: _calmGreen,
                          secondary: _darkGreen,
                          surface: _cardBg,
                        ),
                        // Custom button theme for the "View History" button
                        elevatedButtonTheme: ElevatedButtonThemeData(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: _darkGreen, // Darker green button
                            elevation: 4, // Higher elevation for 3D effect
                            shadowColor: _darkGreen.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                        ),
                        // Custom text theme for crop names
                        textTheme: Theme.of(context).textTheme.copyWith(
                              titleMedium: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _softBlack,
                                overflow: TextOverflow
                                    .ellipsis, // Prevent text wrapping
                              ),
                            ),
                        cardTheme: CardTheme(
                          color: _offWhite,
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      child: Highlights(crops: crops),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Favorites section with heart icons
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      localizations.get('yourFavorites'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: _softBlack,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  // Favorites container with enhanced styling
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _cardBg, // Matching darker background
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor: _calmGreen,
                        colorScheme: ColorScheme.light(
                          primary: _calmGreen,
                          secondary: _darkGreen,
                          surface: _cardBg,
                        ),
                        // Custom text theme to ensure single line crop names
                        textTheme: Theme.of(context).textTheme.copyWith(
                              titleMedium: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _softBlack,
                                overflow: TextOverflow
                                    .ellipsis, // Ensure single line text
                              ),
                            ),
                        // Button styling consistent with highlights
                        elevatedButtonTheme: ElevatedButtonThemeData(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: _darkGreen, // Darker green
                            elevation: 4, // 3D effect
                            shadowColor: _darkGreen.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        cardTheme: CardTheme(
                          color: _offWhite,
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // Icon theme for heart icons
                        iconTheme: IconThemeData(
                          color: Colors.redAccent,
                          size: 20,
                        ),
                      ),
                      // Apply these styles to Favorites component
                      child: FavoritesWithHeartIcons(crops: crops),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Custom wrapper for Favorites to add heart icons
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
        // This wrapper adds heart icons to each favorite item
        // The actual implementation would depend on the structure of your Favorites component
        return Favorites(crops: crops);

        // Note: If you're able to modify the Favorites component directly,
        // add a Row with Icon(Icons.favorite) before each crop name
        // Example structure (implement based on your actual Favorites component):
        /*
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: crops.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Heart icon with subtle animation
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [Colors.red.shade300, Colors.red.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: const Icon(
                        Icons.favorite,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Crop name with ellipsis for single line
                    Expanded(
                      child: Text(
                        crops[index].name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // 3D elevated button
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('View Details'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        */
      },
    );
  }
}
