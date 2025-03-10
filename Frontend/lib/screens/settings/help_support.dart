// lib/screens/settings/help_support.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
        title: const Text('Help & Support'),
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
              leading: const Icon(Icons.play_circle),
              title: const Text('How to use the App?'),
              onTap: () => _launchURL('https://youtube.com/your-tutorial-video'),
            ),
            const Divider(height: 32),
            const Text(
              'Government Agencies',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              //padding: EdgeInsets.symmetric(vertical: 8),
            ),
            const ListTile(
              title: Text('Agriculture Department'),
              subtitle: Text('Hotline: 1920'),
            ),
            const ListTile(
              title: Text('Ministry of Agriculture'),
              subtitle: Text('Phone: 011-2869553'),
            ),
            // Add more agency contacts as needed
          ],
        ),
      ),
    );
  }
}