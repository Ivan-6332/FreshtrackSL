import 'package:flutter/material.dart';
import '../../screens/settings/account_settings.dart';
import '../../screens/settings/legal_info.dart';
import '../../screens/settings/help_support.dart';
import '../../config/app_localizations.dart';
import 'package:provider/provider.dart' as provider;
import '../../providers/language_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String _selectedLanguage = 'en';
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  // Added colors from ExploreTab
  final Color _paleGreen = const Color(0xFFE8F5E9); // Background green
  final Color _lightBg = const Color(0xFFFAFAFA); // Off-white background

  String _getFullName() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final userData = user.userMetadata;
      if (userData != null) {
        final firstName = userData['first_name'] ?? '';
        final lastName = userData['last_name'] ?? '';
        return '$firstName $lastName'.trim();
      }
    }
    return 'User';
  }

  String _getUserEmail() {
    final user = Supabase.instance.client.auth.currentUser;
    return user?.email ?? 'No email';
  }

  @override
  void initState() {
    super.initState();
    // Initialize the selected language after the widget is inserted into the tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentLocale =
          provider.Provider.of<LanguageProvider>(context, listen: false)
              .currentLocale;
      setState(() {
        _selectedLanguage = currentLocale.languageCode;
      });
    });
  }

  String _getLanguageDisplayName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'si':
        return 'සිංහල';
      case 'ta':
        return 'தமிழ்';
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    // Get the current language code from the provider
    final currentLocale =
        provider.Provider.of<LanguageProvider>(context).currentLocale;
    _selectedLanguage =
        currentLocale.languageCode; // Update the selected language

    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        // Updated gradient background same as ExploreTab
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_paleGreen, _lightBg],
            stops: const [0.3, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 48),
              // Profile Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Updated avatar with white background and 3D effect
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.grey[300]!, Colors.grey[600]!],
                            ).createShader(bounds);
                          },
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Styled username text to match avatar
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.grey[700]!, Colors.grey[900]!],
                            ).createShader(bounds);
                          },
                          child: Text(
                            _getFullName(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black12,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Styled email text to match avatar
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.grey[400]!, Colors.grey[600]!],
                            ).createShader(bounds);
                          },
                          child: Text(
                            _getUserEmail(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Settings List
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Language Dropdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Updated to match account settings style
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.green[300]!, Colors.green[500]!],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.language,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            localizations.get('language'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        DropdownButton<String>(
                          value: _selectedLanguage,
                          items: ['en', 'si', 'ta']
                              .map((String code) => DropdownMenuItem<String>(
                            value: code,
                            child: Text(_getLanguageDisplayName(code)),
                          ))
                              .toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedLanguage = newValue;
                                _updateAppLocale(context, newValue);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24), // Increased spacing

                    // Theme Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Updated to match account settings style
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.green[300]!, Colors.green[500]!],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _isDarkMode ? "Dark Theme" : "Light Theme",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // Fixed switch positioning
                        SizedBox(
                          width: 62,
                          child: Container(
                            height: 36,
                            width: 62,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: _isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[300],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.7),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: const Offset(0, -1),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isDarkMode = !_isDarkMode;
                                });
                              },
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    left: _isDarkMode ? 30 : 0,
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: _isDarkMode
                                              ? [
                                            Colors.grey[600]!,
                                            Colors.grey[800]!
                                          ]
                                              : [
                                            Colors.white,
                                            Colors.grey[100]!
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.3),
                                            blurRadius: 3,
                                            spreadRadius: 0,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          _isDarkMode
                                              ? Icons.nightlight_round
                                              : Icons.wb_sunny,
                                          size: 16,
                                          color: _isDarkMode
                                              ? Colors.white70
                                              : Colors.orange,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24), // Increased spacing

                    // Notifications Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Updated to match account settings style
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.green[300]!, Colors.green[500]!],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            _notificationsEnabled
                                ? Icons.notifications_active
                                : Icons.notifications_off,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            localizations.get('notifications'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // Fixed switch positioning
                        SizedBox(
                          width: 62,
                          child: Container(
                            height: 36,
                            width: 62,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: _notificationsEnabled
                                  ? Colors.green[200]
                                  : Colors.grey[300],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.7),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: const Offset(0, -1),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _notificationsEnabled =
                                  !_notificationsEnabled;
                                });
                              },
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    left: _notificationsEnabled ? 30 : 0,
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: _notificationsEnabled
                                              ? [
                                            Colors.green[300]!,
                                            Colors.green[500]!
                                          ]
                                              : [
                                            Colors.white,
                                            Colors.grey[100]!
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.3),
                                            blurRadius: 3,
                                            spreadRadius: 0,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          _notificationsEnabled
                                              ? Icons.notifications_active
                                              : Icons.notifications_off,
                                          size: 16,
                                          color: _notificationsEnabled
                                              ? Colors.white
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 45),
                    // Settings Options with updated styling
                    // Account Settings with background and 3D icon
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.green[300]!, Colors.green[500]!],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child:
                          const Icon(Icons.settings, color: Colors.white),
                        ),
                        title: Text(
                          localizations.get('accountSettings'),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const AccountSettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    // Legal Info with background and 3D icon
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.green[300]!, Colors.green[500]!],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.description,
                              color: Colors.white),
                        ),
                        title: Text(
                          localizations.get('legalInfo'),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LegalInfoScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    // Help & Support with background and 3D icon
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.green[300]!, Colors.green[500]!],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.help, color: Colors.white),
                        ),
                        title: Text(
                          localizations.get('helpSupport'),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSupportScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 70),
                    // Logout Button with 3D styling
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.red[400]!, Colors.red[700]!],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: const Offset(0, -1),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          localizations.get('logOut'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateAppLocale(BuildContext context, String languageCode) {
    provider.Provider.of<LanguageProvider>(context, listen: false)
        .changeLanguage(languageCode);
  }
}
