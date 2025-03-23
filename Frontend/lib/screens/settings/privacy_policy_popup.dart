import 'package:flutter/material.dart';

class PrivacyPolicyPopup extends StatelessWidget {
  const PrivacyPolicyPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF4CAF50);
    final Color lightGreen = const Color(0xFFE8F5E9);

    // Get screen dimensions for responsive sizing
    final Size screenSize = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 8,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.03,
      ),
      child: Container(
        width: screenSize.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: screenSize.height * 0.85,
          minHeight: screenSize.height * 0.7,
          maxWidth: 700, // Maximum width on larger screens
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryGreen, primaryGreen.withOpacity(0.8)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.privacy_tip, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Center(
                      child: Text(
                        'Privacy Policy for FreshTrack SL',
                        style: TextStyle(
                          fontSize: 20, // Increased font size
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Effective Date
                    Center(
                      child: Text(
                        'Effective Date: March 23, 2025',
                        style: TextStyle(
                          fontSize: 15, // Increased font size
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Increased spacing
                    // Welcome Text
                    Text(
                      'Welcome to FreshTrack SL, a demand-management mobile app designed to reduce fresh produce wastage in Sri Lanka. Your privacy is important to us, and this Privacy Policy explains how we collect, use, and protect your personal data.',
                      style: TextStyle(fontSize: 15), // Increased font size
                    ),
                    const SizedBox(height: 20), // Increased spacing

                    // Section 1
                    _buildSection(
                      '1. Information We Collect',
                      'When you use FreshTrack SL, we may collect the following types of information:',
                      [
                        'Personal Information: Name, phone number, and email address (if provided).',
                        'Usage Data: App usage statistics, interactions, and preferences.',
                        'Location Data: If enabled, we may collect location data to provide localized demand forecasts and pricing information.',
                        'Device Information: Device type, operating system, and app version to improve performance and user experience.',
                      ],
                      primaryGreen,
                      lightGreen,
                    ),

                    // Section 2
                    _buildSection(
                      '2. How We Use Your Information',
                      'We use the collected data for the following purposes:',
                      [
                        'To provide accurate demand forecasts for farmers and wholesalers.',
                        'To personalize content, such as crop price reports and relevant agency contacts.',
                        'To enhance app security and prevent unauthorized access.',
                        'To analyze and improve app performance and user experience.',
                        'To communicate with users regarding important updates, promotions, or support requests.',
                      ],
                      primaryGreen,
                      lightGreen,
                    ),

                    // Section 3
                    _buildSection(
                      '3. Data Sharing & Disclosure',
                      'We do not sell or rent your personal data. However, we may share information in the following situations:',
                      [
                        'With Government & Economic Centers: To enhance agricultural planning and sustainability efforts.',
                        'With Service Providers: Trusted third parties that help us operate our app (e.g., hosting, analytics).',
                        'Legal Compliance: If required by law or to protect our rights, safety, and property.',
                      ],
                      primaryGreen,
                      lightGreen,
                    ),

                    // Section 4
                    _buildSection(
                      '4. Data Security',
                      'We implement industry-standard security measures to protect your data from unauthorized access or breaches. However, no method of transmission is 100% secure, and users should take precautions when sharing information online.',
                      [],
                      primaryGreen,
                      lightGreen,
                    ),

                    // Section 5
                    _buildSection(
                      '5. Your Choices & Rights',
                      'You have the right to:',
                      [
                        'Access, update, or delete your personal data by contacting us.',
                        'Disable location services via your device settings.',
                        'Opt-out of promotional communications at any time.',
                      ],
                      primaryGreen,
                      lightGreen,
                    ),

                    // Section 6
                    _buildSection(
                      '6. Third-Party Links & Services',
                      'FreshTrack SL may contain links to third-party websites or services. We are not responsible for their privacy policies or data practices.',
                      [],
                      primaryGreen,
                      lightGreen,
                    ),

                    // Section 7
                    _buildSection(
                      '7. Updates to This Policy',
                      'We may update this Privacy Policy from time to time. Any significant changes will be communicated via app notifications or email.',
                      [],
                      primaryGreen,
                      lightGreen,
                    ),

                    // Section 8
                    _buildSection(
                      '8. Contact Us',
                      'If you have any questions about this Privacy Policy, please contact us at:',
                      [],
                      primaryGreen,
                      lightGreen,
                    ),

                    // Contact info - Placed email and phone in a column layout
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.email, color: primaryGreen, size: 18),
                              const SizedBox(width: 6),
                              Text('Email: support@freshtrack.sl',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone, color: primaryGreen, size: 18),
                              const SizedBox(width: 6),
                              Text('Phone: +94 123 456 789',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Agreement text
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'By using FreshTrack SL, you agree to the terms outlined in this Privacy Policy.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    // Logo or app icon
                    const SizedBox(height: 16),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.eco, color: primaryGreen, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '🌱',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer with accept button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0), // Increased padding
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'CLOSE',
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Increased button size
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'I ACCEPT',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      String title,
      String subtitle,
      List<String> bulletPoints,
      Color primaryColor,
      Color backgroundColor,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20), // Increased margin
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: backgroundColor.darker(10)),
      ),
      padding: const EdgeInsets.all(16), // Increased padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17, // Increased font size
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10), // Increased spacing
          Text(
            subtitle,
            style: TextStyle(fontSize: 15), // Increased font size
          ),
          if (bulletPoints.isNotEmpty) const SizedBox(height: 10), // Increased spacing
          ...bulletPoints.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 6), // Increased padding
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: primaryColor, fontSize: 15)),
                Expanded(
                  child: Text(
                    point,
                    style: TextStyle(fontSize: 15), // Increased font size
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// Extension to darken colors
extension ColorExtension on Color {
  Color darker(int percent) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * value).round(),
      (green * value).round(),
      (blue * value).round(),
    );
  }
}