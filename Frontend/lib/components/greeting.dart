import 'package:flutter/material.dart';
import '../config/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class Greeting extends StatefulWidget {
  const Greeting({super.key});

  @override
  State<Greeting> createState() => _GreetingState();
}

class _GreetingState extends State<Greeting> {
  String _firstName = '';
  late Color _avatarColor;
  late String _initials;

  @override
  void initState() {
    super.initState();
    _loadUserName();

    // Generate a random color for the avatar
    final random = Random();
    final colorsList = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    _avatarColor = colorsList[random.nextInt(colorsList.length)];
  }

  Future<void> _loadUserName() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final userData = user.userMetadata;
        if (userData != null && userData['first_name'] != null) {
          setState(() {
            _firstName = userData['first_name'];
            // Generate initials from first name
            _initials = _firstName.isNotEmpty ? _firstName[0].toUpperCase() : "?";
          });
        }
      } else {
        setState(() {
          _initials = "?";
        });
      }
    } catch (e) {
      print('Error loading user name: $e');
      setState(() {
        _initials = "?";
      });
    }
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
    final helloTextSize = isSmallScreen ? 28.0 : (isMediumScreen ? 38.0 : 46.0);
    final nameTextSize = isSmallScreen ? 22.0 : (isMediumScreen ? 30.0 : 36.0);
    final avatarSize = isSmallScreen ? 60.0 : (isMediumScreen ? 75.0 : 90.0);
    final initialsSize = isSmallScreen ? 24.0 : (isMediumScreen ? 32.0 : 40.0);

    // Calculate responsive padding
    final containerPadding = EdgeInsets.symmetric(
      horizontal: isSmallScreen ? 16.0 : (isMediumScreen ? 24.0 : 32.0),
      vertical: isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0),
    );

    // Calculate responsive spacing
    final spacingWidth = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final spacingHeight = isSmallScreen ? 4.0 : (isMediumScreen ? 6.0 : 8.0);

    // Calculate responsive container properties
    final borderRadius = isSmallScreen ? 16.0 : (isMediumScreen ? 20.0 : 24.0);
    final containerMargin = EdgeInsets.all(isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0));

    return Padding(
      padding: containerMargin,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          // Removed border
          // border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          // Kept the shadow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: containerPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Generated profile avatar with initials
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: _avatarColor,
                child: Text(
                  _initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: initialsSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: spacingWidth),
            // Column for "Hello" and name on separate lines
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hello,",
                    style: TextStyle(
                      fontSize: helloTextSize,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.1,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacingHeight),
                  Text(
                    _firstName.isNotEmpty ? _firstName : "there",
                    style: TextStyle(
                      fontSize: nameTextSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      height: 1.1,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}