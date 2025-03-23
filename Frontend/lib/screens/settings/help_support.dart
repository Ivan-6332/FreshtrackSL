import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showFeatureUnavailableDialog(BuildContext context, String featureTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Calculate responsive sizes based on screen width
        final double screenWidth = MediaQuery.of(context).size.width;
        final double dialogWidth = screenWidth > 600 ? 400 : screenWidth * 0.85;
        final double iconSize = screenWidth > 600 ? 70 : 60;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Container(
            width: dialogWidth,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top illustration/icon
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.green[300]!, Colors.green[600]!],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.build_circle_outlined,
                    color: Colors.white,
                    size: iconSize * 0.6,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 16),

                // Message
                Text(
                  'Sorry, "$featureTitle" is not available right now. We\'re working hard to bring this feature to you soon!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 16 : 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Button
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.green[400]!, Colors.green[600]!],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Got it',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
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
        title: const Text('Help & Support'),
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
            _buildHelpItem(
              context,
              icon: Icons.play_circle,
              title: 'How to use the App?',
              gradientColors: [Colors.green[300]!, Colors.green[500]!],
              onTap: () => _showFeatureUnavailableDialog(context, 'How to use the App?'),
            ),
            _buildHelpItem(
              context,
              icon: Icons.photo_camera,
              title: 'How to change your Profile Picture',
              gradientColors: [Colors.green[300]!, Colors.green[500]!],
              onTap: () => _showFeatureUnavailableDialog(context, 'How to change your Profile Picture'),
            ),
            _buildHelpItem(
              context,
              icon: Icons.person,
              title: 'How to change your Username',
              gradientColors: [Colors.green[300]!, Colors.green[500]!],
              onTap: () => _showFeatureUnavailableDialog(context, 'How to change your Username'),
            ),
            _buildHelpItem(
              context,
              icon: Icons.lock,
              title: 'How to change your Password',
              gradientColors: [Colors.green[300]!, Colors.green[500]!],
              onTap: () => _showFeatureUnavailableDialog(context, 'How to change your Password'),
            ),
            _buildHelpItem(
              context,
              icon: Icons.phone,
              title: 'How to change your Mobile Number',
              gradientColors: [Colors.green[300]!, Colors.green[500]!],
              onTap: () => _showFeatureUnavailableDialog(context, 'How to change your Mobile Number'),
            ),

            const SizedBox(height: 24),

            _buildSectionHeader(
              'Government Agencies',
              gradientColors: [Colors.green.shade500, Colors.teal.shade400],
            ),

            _buildAgencyItem(
              context,
              title: 'Agriculture Department',
              subtitle: 'Hotline: 1920',
              gradientColors: [Colors.green.shade400, Colors.teal.shade300],
            ),

            _buildAgencyItem(
              context,
              title: 'Ministry of Agriculture',
              subtitle: 'Phone: 011-2869553',
              gradientColors: [Colors.green.shade400, Colors.teal.shade300],
            ),
            // Add more agency contacts as needed
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(
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

  Widget _buildSectionHeader(String title, {required List<Color> gradientColors}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAgencyItem(
      BuildContext context, {
        required String title,
        required String subtitle,
        required List<Color> gradientColors,
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
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            subtitle,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        trailing: const Icon(Icons.phone, size: 20),
        onTap: () {
          // Handle phone call action
          final phone = subtitle.split(': ')[1];
          _launchURL('tel:$phone');
        },
      ),
    );
  }
}