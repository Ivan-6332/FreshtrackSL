import 'package:flutter/material.dart';
import '../config/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Greeting extends StatefulWidget {
  const Greeting({super.key});

  @override
  State<Greeting> createState() => _GreetingState();
}

class _GreetingState extends State<Greeting> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _firstName = '';

  @override
  void initState() {
    super.initState();

    // Create an animation controller with a 1.5 second duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true); // Auto-repeat the animation with reverse

    // Create a Tween animation that goes from -0.3 to 0.3 radians (waving motion)
    _animation = Tween<double>(
      begin: -0.3,
      end: 0.3,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        // Using elasticOut for a more natural "wave" feel
        curve: Curves.elasticOut,
      ),
    );

    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final userData = user.userMetadata;
        if (userData != null && userData['first_name'] != null) {
          setState(() {
            _firstName = userData['first_name'];
          });
        }
      }
    } catch (e) {
      print('Error loading user name: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic sizing based on screen dimensions
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    final isLargeScreen = screenWidth >= 600;

    // Calculate responsive font sizes
    final emojiSize = isSmallScreen ? 24.0 : (isMediumScreen ? 32.0 : 40.0);
    final hiTextSize = isSmallScreen ? 28.0 : (isMediumScreen ? 38.0 : 46.0);
    final nameTextSize = isSmallScreen ? 22.0 : (isMediumScreen ? 30.0 : 36.0);

    // Calculate responsive padding
    final containerPadding = EdgeInsets.symmetric(
      horizontal: isSmallScreen ? 12.0 : (isMediumScreen ? 20.0 : 28.0),
      vertical: isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 16.0),
    );

    // Calculate responsive spacing
    final spacingWidth1 = isSmallScreen ? 4.0 : (isMediumScreen ? 8.0 : 12.0);
    final spacingWidth2 = isSmallScreen ? 6.0 : (isMediumScreen ? 12.0 : 16.0);

    // Calculate responsive shadow properties
    final shadowOffset = isSmallScreen ?
    const Offset(1, 1) : (isMediumScreen ? const Offset(2, 2) : const Offset(3, 3));
    final shadowBlur = isSmallScreen ? 6.0 : (isMediumScreen ? 10.0 : 14.0);

    // Calculate responsive container properties
    final borderRadius = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final containerMargin = EdgeInsets.all(isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0));

    return Padding(
      padding: containerMargin,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            colors: [
              Colors.green.shade500,
              Colors.teal.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: isSmallScreen ? 10.0 : (isMediumScreen ? 15.0 : 20.0),
              offset: Offset(0, isSmallScreen ? 3.0 : (isMediumScreen ? 5.0 : 7.0)),
              spreadRadius: isSmallScreen ? 1.0 : (isMediumScreen ? 2.0 : 3.0),
            ),
          ],
        ),
        padding: containerPadding,
        // Use a FittedBox to ensure the greeting fits within the available space
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated waving hand emoji
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                        isSmallScreen ? -1.0 : -2.0,
                        isSmallScreen ? -1.0 : -2.0
                    ),
                    child: Transform.rotate(
                      angle: _animation.value,
                      alignment: Alignment.bottomCenter, // Rotate from bottom (like a wrist)
                      child: Text(
                        "👋",
                        style: TextStyle(
                          fontSize: emojiSize,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: spacingWidth1),
              Text(
                "Hi",
                style: TextStyle(
                  fontSize: hiTextSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: isSmallScreen ? -0.3 : -0.5,
                  height: 1.2,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: shadowOffset,
                      blurRadius: shadowBlur,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacingWidth2),
              // Wrap name in a flexible container to allow line breaking on very small screens
              Flexible(
                child: Text(
                  _firstName.isNotEmpty ? _firstName : "there",
                  style: TextStyle(
                    fontSize: nameTextSize,
                    fontWeight: FontWeight.w800,
                    letterSpacing: isSmallScreen ? -0.2 : -0.3,
                    height: 1.2,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(
                            isSmallScreen ? 1.0 : 1.5,
                            isSmallScreen ? 1.0 : 1.5
                        ),
                        blurRadius: isSmallScreen ? 5.0 : 8.0,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                  // Allow text to wrap on very small screens
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}