import 'package:flutter/material.dart';

class TermsAndConditionsPopup extends StatelessWidget {
  const TermsAndConditionsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isMobile = size.width <= 600;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 24 : 40,
      ),
      child: Container(
        width: isTablet ? size.width * 0.85 : size.width,
        constraints: BoxConstraints(
          maxHeight: size.height * 0.85,
          maxWidth: 900,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, const Color(0xFFF8FFF8)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.green[400]!, Colors.green[600]!],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 20 : 16,
                  horizontal: isTablet ? 32 : 24
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: isTablet ? 28 : 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(isTablet ? 32 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle('FreshTrack SL', isTablet),
                    const SizedBox(height: 4),
                    _buildSubtitle('Effective Date: [Insert Date]', isTablet),
                    const SizedBox(height: 16),
                    _buildParagraph(
                        'Welcome to FreshTrack SL, a mobile application designed to optimize demand management and reduce fresh produce wastage in Sri Lanka. By using FreshTrack SL, you agree to the following Terms and Conditions. Please read them carefully before accessing or using our app.',
                        isTablet
                    ),

                    _buildSection('1. Acceptance of Terms', isTablet),
                    _buildParagraph(
                        'By accessing or using FreshTrack SL, you agree to be bound by these Terms and Conditions, our Privacy Policy, and all applicable laws. If you do not agree, you must discontinue use of the app immediately.',
                        isTablet
                    ),

                    _buildSection('2. Eligibility', isTablet),
                    _buildParagraph(
                        'FreshTrack SL is intended for farmers, wholesalers, and stakeholders in the agriculture industry in Sri Lanka. By using this app, you confirm that you are at least 18 years old or have obtained necessary parental/guardian consent.',
                        isTablet
                    ),

                    _buildSection('3. Use of the App', isTablet),
                    _buildParagraph(
                        'You agree to use FreshTrack SL solely for lawful purposes, including:',
                        isTablet
                    ),
                    _buildBulletPoints([
                      'Accessing demand forecasts for crops.',
                      'Viewing daily crop prices and market trends.',
                      'Contacting relevant agencies and economic centers.',
                    ], isTablet),
                    _buildParagraph('You must not use the app to:', isTablet),
                    _buildBulletPoints([
                      'Engage in fraudulent, misleading, or harmful activities.',
                      'Disrupt or interfere with the app\'s functionality.',
                      'Attempt to reverse-engineer, hack, or exploit vulnerabilities in the system.',
                    ], isTablet),

                    _buildSection('4. User Accounts & Data', isTablet),
                    _buildBulletPoints([
                      'You are responsible for keeping your login credentials secure.',
                      'You must not share your account details with others.',
                      'We reserve the right to suspend or terminate accounts that violate these Terms.',
                    ], isTablet),

                    _buildSection('5. Accuracy of Information', isTablet),
                    _buildParagraph(
                        'FreshTrack SL strives to provide accurate and up-to-date demand forecasts, crop prices, and contacts. However, we do not guarantee the completeness, reliability, or accuracy of the data provided. Users should verify critical information before making decisions.',
                        isTablet
                    ),

                    _buildSection('6. Intellectual Property Rights', isTablet),
                    _buildParagraph(
                        'All content within FreshTrack SL, including logos, text, graphics, and data, is the exclusive property of FreshTrack SL and protected by intellectual property laws. You may not reproduce, modify, or distribute any content without our explicit permission.',
                        isTablet
                    ),

                    _buildSection('7. Limitation of Liability', isTablet),
                    _buildParagraph(
                        'FreshTrack SL is provided "as is" without any warranties, express or implied. We are not responsible for:',
                        isTablet
                    ),
                    _buildBulletPoints([
                      'Any financial losses, damages, or crop wastage resulting from reliance on our data.',
                      'Any disruptions, errors, or bugs within the app.',
                      'Unauthorized access to your account due to your negligence.',
                    ], isTablet),

                    _buildSection('8. Third-Party Services', isTablet),
                    _buildParagraph(
                        'The app may contain links to third-party websites or services. We do not endorse or take responsibility for their content, terms, or privacy practices.',
                        isTablet
                    ),

                    _buildSection('9. Modifications & Termination', isTablet),
                    _buildBulletPoints([
                      'We reserve the right to modify these Terms at any time. Continued use of the app after changes are made constitutes acceptance of the updated Terms.',
                      'We may suspend or discontinue FreshTrack SL at any time without prior notice.',
                    ], isTablet),

                    _buildSection('10. Governing Law', isTablet),
                    _buildParagraph(
                        'These Terms and Conditions are governed by the laws of Sri Lanka. Any disputes arising from the use of FreshTrack SL shall be resolved in accordance with Sri Lankan legal procedures.',
                        isTablet
                    ),

                    _buildSection('11. Contact Information', isTablet),
                    _buildParagraph(
                        'If you have any questions or concerns regarding these Terms, please contact us:',
                        isTablet
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.email, size: isTablet ? 20 : 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                'Email: [Insert Email]',
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 15,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.phone, size: isTablet ? 20 : 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                'Phone: [Insert Phone Number]',
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 15,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isTablet ? 32 : 24),
                    _buildParagraph(
                      'By using FreshTrack SL, you acknowledge that you have read, understood, and agreed to these Terms and Conditions.',
                      isTablet,
                      isBold: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rocket_launch, color: Colors.green[600], size: isTablet ? 28 : 24),
                        const SizedBox(width: 8),
                        Icon(Icons.eco, color: Colors.green[600], size: isTablet ? 28 : 24),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer with accept button
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 20 : 16,
                  horizontal: isTablet ? 32 : 24
              ),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Close',
                      style: TextStyle(fontSize: isTablet ? 16 : 14),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 32 : 24,
                          vertical: isTablet ? 16 : 12
                      ),
                    ),
                    child: Text(
                      'I Agree',
                      style: TextStyle(fontSize: isTablet ? 16 : 14),
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

  Widget _buildTitle(String text, bool isTablet) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isTablet ? 26 : 22,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildSubtitle(String text, bool isTablet) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isTablet ? 16 : 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildSection(String text, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(top: isTablet ? 32 : 24, bottom: isTablet ? 12 : 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isTablet ? 22 : 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text, bool isTablet, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isTablet ? 17 : 15,
          height: 1.5,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildBulletPoints(List<String> points, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(left: 16, bottom: isTablet ? 20 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: points.map((point) {
          return Padding(
            padding: EdgeInsets.only(bottom: isTablet ? 10 : 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: isTablet ? 8 : 6),
                  height: isTablet ? 8 : 6,
                  width: isTablet ? 8 : 6,
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: isTablet ? 12 : 10),
                Expanded(
                  child: Text(
                    point,
                    style: TextStyle(
                      fontSize: isTablet ? 17 : 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}