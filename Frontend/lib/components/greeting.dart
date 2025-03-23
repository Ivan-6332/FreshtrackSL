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
  String? _profileImageUrl;
  final String _defaultAvatarPath = 'assets/images/default_avatar.jpg';

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Generate a random color for the avatar background (fallback)
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

  Future<void> _loadUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final userData = user.userMetadata;
        if (userData != null && userData['first_name'] != null) {
          setState(() {
            _firstName = userData['first_name'];
            _fetchProfileImage(user.id);
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _fetchProfileImage(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('avatar_url')
          .eq('id', userId)
          .single();

      if (response != null && response['avatar_url'] != null) {
        setState(() {
          _profileImageUrl = response['avatar_url'];
        });
      }
    } catch (e) {
      print('Error fetching profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic sizing based on screen dimensions
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    // Calculate responsive font sizes
    final greetingTextSize = isSmallScreen ? 24.0 : (isMediumScreen ? 32.0 : 40.0);
    final avatarSize = isSmallScreen ? 60.0 : (isMediumScreen ? 60.0 : 90.0);

    // Calculate responsive padding
    final containerPadding = EdgeInsets.symmetric(
      horizontal: isSmallScreen ? 16.0 : (isMediumScreen ? 0.0 : 32.0),
      vertical: isSmallScreen ? 12.0 : (isMediumScreen ? 0.0 : 20.0),
    );

    // Calculate responsive spacing
    final spacingWidth = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);

    // Calculate responsive container properties
    final borderRadius = isSmallScreen ? 16.0 : (isMediumScreen ? 20.0 : 24.0);
    final containerMargin = EdgeInsets.all(isSmallScreen ? 12.0 : (isMediumScreen ? 0.0 : 20.0));

    // Create the greeting text on a single line
    final greetingText = "Hello, ${_firstName.isNotEmpty ? "$_firstName!": "there!"}";

    return Padding(
      padding: containerMargin,
      child: Container(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: containerPadding,
        child: Row(
          children: [
            // Profile image avatar
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: .5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                    ? Image.network(
                  _profileImageUrl!,
                  width: avatarSize,
                  height: avatarSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to default avatar image if network image fails to load
                    return Image.asset(
                      _defaultAvatarPath,
                      width: avatarSize,
                      height: avatarSize,
                      fit: BoxFit.cover,
                      // If default image also fails, fall back to colored circle
                      errorBuilder: (context, error, stackTrace) {
                        return CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundColor: _avatarColor,
                          child: Text(
                            _firstName.isNotEmpty ? _firstName[0].toUpperCase() : "?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: avatarSize * 0.4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
                    : Image.asset(
                  _defaultAvatarPath,
                  width: avatarSize,
                  height: avatarSize,
                  fit: BoxFit.cover,
                  // If default image fails, fall back to colored circle
                  errorBuilder: (context, error, stackTrace) {
                    return CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundColor: _avatarColor,
                      child: Text(
                        _firstName.isNotEmpty ? _firstName[0].toUpperCase() : "?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: avatarSize * 0.4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: spacingWidth),
            // Single line greeting text - simplified
            Expanded(
              child: Text(
                greetingText,
                style: TextStyle(
                  fontSize: greetingTextSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.215,
                  height: 1.1,
                  color: Colors.black,
                  // shadows: [
                  //   Shadow(
                  //     offset: const Offset(1, 1),
                  //     blurRadius: 3,
                  //     color: Colors.black.withOpacity(0.3),
                  //   ),
                  // ],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1, // Force single line
              ),
            ),
          ],
        ),
      ),
    );
  }
}