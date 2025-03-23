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

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  // Current selected tab index
  int _currentIndex = 0;

  // Animation controller for tab transitions
  late AnimationController _animationController;

  // List of tab widgets - each wrapped in AutomaticKeepAlive
  final List<Widget> _tabs = [
    const KeepAlivePage(child: HomeTab()),
    const KeepAlivePage(child: ExploreTab()),
    const KeepAlivePage(child: MapTab()),
    const KeepAlivePage(child: ProfileTab()),
  ];

  // Updated colors from ExploreTab
  final Color _primaryGreen =
      const Color(0xFF4CAF50); // Main green from ExploreTab
  final Color _accentGreen =
      const Color(0xFF81C784); // Secondary green from ExploreTab
  final Color _paleGreen =
      const Color(0xFFE8F5E9); // Background green from ExploreTab
  final Color _darkText =
      const Color(0xFF212121); // Near black text from ExploreTab
  final Color _lightBg =
      const Color(0xFFFAFAFA); // Off-white background from ExploreTab
  final Color _inactiveGrey =
      const Color(0xFF9E9E9E); // Medium grey for inactive icons

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
      // Set background to gradient like ExploreTab
      extendBody: true, // Allow content to draw behind bottom nav
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
          // Use IndexedStack instead of AnimatedSwitcher to preserve state
          child: IndexedStack(
            index: _currentIndex,
            children: _tabs,
          ),
        ),
      ),
      // Enhanced 3D styled bottom navigation bar
      bottomNavigationBar: Container(
        height: 65 +
            MediaQuery.of(context)
                .padding
                .bottom, // Adjust height for different devices
        // margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(16),
          // Enhanced 3D effect with layered shadows
          boxShadow: [
            // Outer shadow
            BoxShadow(
              color: _primaryGreen.withOpacity(0.15),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
            // Inner shadow for depth
            BoxShadow(
              color: Colors.white,
              blurRadius: 5,
              spreadRadius: -2,
              offset: const Offset(0, -2),
            ),
            // Bottom highlight for 3D effect
            BoxShadow(
              color: _accentGreen.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, -3),
            ),
          ],
          // Subtle gradient overlay for 3D effect
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.9),
            ],
          ),
          // Subtle border
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home'),
                _buildNavItem(1, Icons.search, 'Explore'),
                _buildNavItem(2, Icons.attach_money, 'Pricing'),
                _buildNavItem(3, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced nav item builder with 3D effect and centered icons
  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () {
        _animationController.forward(from: 0.0);
        setState(() {
          _currentIndex = index;
        });
      },
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 70,
        height: 65,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _paleGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          // Add 3D effect to selected item
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _accentGreen.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 3),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    blurRadius: 10,
                    spreadRadius: -2,
                    offset: const Offset(0, -3),
                  ),
                ]
              : [],
          // Add subtle gradient to selected item
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _paleGreen.withOpacity(0.8),
                    _paleGreen.withOpacity(0.6),
                  ],
                )
              : null,
          // Add subtle border to selected item
          border: isSelected
              ? Border.all(
                  color: _accentGreen.withOpacity(0.3),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the content vertically
          children: [
            // Icon with 3D effect - centered
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: isSelected
                  ? Matrix4.translationValues(0, -2, 0)
                  : Matrix4.translationValues(0, 0, 0),
              child: Icon(
                icon,
                color: isSelected ? _primaryGreen : _inactiveGrey,
                size: isSelected ? 26 : 24,
                // shadows: isSelected
                //     ? [
                //         Shadow(
                //           color: _accentGreen.withOpacity(0.5),
                //           blurRadius: 8,
                //           offset: const Offset(0, 3),
                //         ),
                //       ]
                //     : null,
              ),
            ),
            const SizedBox(height: 4),
            // Label with 3D effect
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected ? _primaryGreen : _inactiveGrey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                // shadows: isSelected
                //     ? [
                //         Shadow(
                //           color: _accentGreen.withOpacity(0.5),
                //           blurRadius: 2,
                //           offset: const Offset(0, 1),
                //         ),
                //       ]
                //     : null,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to keep pages alive when not visible
class KeepAlivePage extends StatefulWidget {
  final Widget child;

  const KeepAlivePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
