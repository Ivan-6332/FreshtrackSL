// lib/screens/tabs/profile_tab.dart
import 'package:flutter/material.dart';
import '../../screens/settings/account_settings.dart';
import '../../screens/settings/legal_info.dart';
import '../../screens/settings/help_support.dart';
import '../../config/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

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

  @override
  void initState() {
    super.initState();
    // Initialize the selected language after the widget is inserted into the tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentLocale =
          Provider.of<LanguageProvider>(context, listen: false).currentLocale;
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
    final currentLocale = Provider.of<LanguageProvider>(context).currentLocale;
    _selectedLanguage =
        currentLocale.languageCode; // Update the selected language

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
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      child:
                      const Icon(Icons.person, size: 40, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.get('username'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'user@domain.com',
                          style: const TextStyle(
                            color: Colors.grey,
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Language Dropdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(localizations.get('language')),
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
                    const SizedBox(height: 16),
                    // Theme Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(localizations.get('lightTheme')),
                        Switch(
                          value: _isDarkMode,
                          onChanged: (bool value) {
                            setState(() {
                              _isDarkMode = value;
                            });
                          },
                        ),
                      ],
                    ),
                    // Notifications Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(localizations.get('notifications')),
                        Switch(
                          value: _notificationsEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Settings Options
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(localizations.get('accountSettings')),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountSettingsScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: Text(localizations.get('legalInfo')),
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
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: Text(localizations.get('helpSupport')),
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
                    const SizedBox(height: 24),
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(localizations.get('logOut')),
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
    Provider.of<LanguageProvider>(context, listen: false)
        .changeLanguage(languageCode);
  }
}