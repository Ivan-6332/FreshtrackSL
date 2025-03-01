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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.play_circle),
            title: const Text('How to use the App?'),
            onTap: () => _launchURL('https://youtube.com/your-tutorial-video'),
          )
          // Add agency contacts here
        ],
      ),
    );
  }
}