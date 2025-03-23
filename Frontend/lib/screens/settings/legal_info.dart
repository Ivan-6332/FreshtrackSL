import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// Import the privacy policy popup
import 'privacy_policy_popup.dart';
// Import our new terms and conditions popup
import 'terms_and_conditions_popup.dart';

class LegalInfoScreen extends StatelessWidget {
  const LegalInfoScreen({super.key});

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  void showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const PrivacyPolicyPopup();
      },
    );
  }

  void showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TermsAndConditionsPopup();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Colors
    final Color paleGreen = const Color(0xFFE8F5E9); // Background green
    final Color lightBg = const Color(0xFFFAFAFA); // Off-white background

    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal Info'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [paleGreen, lightBg],
            stops: const [0.3, 1.0],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            buildLegalItem(
              context,
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              gradientColors: [Colors.green[300]!, Colors.green[500]!],
              onTap: () => showPrivacyPolicy(context),
            ),
            buildLegalItem(
              context,
              icon: Icons.description,
              title: 'Terms and Conditions',
              gradientColors: [Colors.green[300]!, Colors.green[500]!],
              onTap: () => showTermsAndConditions(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLegalItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required List<Color> gradientColors,
        required VoidCallback onTap,
      }) {
    return Container(
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
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}