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
          // add links here
        ],
      ),
    );
  }
}
