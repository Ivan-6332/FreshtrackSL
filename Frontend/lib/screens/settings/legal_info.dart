// lib/screens/settings/legal_info.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalInfoScreen extends StatelessWidget {
  const LegalInfoScreen({super.key});

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Added colors from ExploreTab
    final Color _paleGreen = const Color(0xFFE8F5E9); // Background green
    final Color _lightBg = const Color(0xFFFAFAFA); // Off-white background

    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal Info'),
      ),
      body: Container(
        // Added gradient background same as ExploreTab
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_paleGreen, _lightBg],
            stops: const [0.3, 1.0],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: () => _launchURL('https://your-privacy-policy-url.com'),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms and Conditions'),
              onTap: () => _launchURL('https://your-terms-url.com'),
            ),
          ],
        ),
      ),
    );
  }
}