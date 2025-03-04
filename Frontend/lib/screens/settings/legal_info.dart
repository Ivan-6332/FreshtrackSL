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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal Info'),
      ),
      body: ListView(
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
    );
  }
}
