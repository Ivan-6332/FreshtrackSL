// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import '../tabs/home_tab.dart';
import '../tabs/explore_tab.dart';
import '../tabs/map_tab.dart';
import '../tabs/profile_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  // Current selected tab index
  int _currentIndex = 0;

  // Animation controller for tab transitions
  late AnimationController _animationController;

  // List of tab widgets
  final List<Widget> _tabs = [
    const HomeTab(),
    const ExploreTab(),
    const MapTab(),
    const ProfileTab(),
  ];

  // Custom theme colors
  final Color _primaryGreen = const Color(0xFF2E7D32); // Forest green
  final Color _blackColor = Colors.black87;
  final Color _whiteColor = Colors.white;
  final Color _inactiveGrey = const Color(0xFF757575);

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for smooth transitions
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background to white
      backgroundColor: _whiteColor,
      // Apply SafeArea for proper device padding
      body: SafeArea(
        child: AnimatedSwitcher(
          // Add smooth transition between tabs
          duration: const Duration(milliseconds: 300),
          child: _tabs[_currentIndex],
        ),
      ),
      // Custom styled bottom navigation bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _whiteColor,
          // Add subtle shadow to navigation bar
          boxShadow: [
            BoxShadow(
              color: _blackColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: _whiteColor,
          selectedItemColor: _primaryGreen,
          unselectedItemColor: _inactiveGrey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0, // Remove default elevation as we're using custom shadow
          // Add subtle animation on item selection
          onTap: (index) {
            _animationController.forward(from: 0.0);
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: _currentIndex == 0 ? _primaryGreen : _inactiveGrey),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined, color: _currentIndex == 1 ? _primaryGreen : _inactiveGrey),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined, color: _currentIndex == 2 ? _primaryGreen : _inactiveGrey),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, color: _currentIndex == 3 ? _primaryGreen : _inactiveGrey),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}