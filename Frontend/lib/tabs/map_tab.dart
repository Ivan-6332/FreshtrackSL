// lib/screens/tabs/map_tab.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  DateTime selectedDate = DateTime.now();
  bool isDownloading = false;
  String? errorMessage;

  // Enhanced color palette - matching with HomeTab
  final Color _primaryGreen = const Color(0xFF1B5E20); // Dark green from HomeTab
  final Color _accentGreen = const Color(0xFF81C784); // Secondary green
  final Color _paleGreen = const Color(0xFFE8F5E9); // Background green
  final Color _darkText = const Color(0xFF212121); // Near black for text
  final Color _lightBg = const Color(0xFFFAFAFA); // Off-white background
  final Color _darkGreen = const Color(0xFF004D2A); // Darker green for accents
  final Color _lightGreen = const Color(0xFFE8F5E9); // Very light green for buttons
  final Color _lightText = const Color(0xFFFFFFFF); // White text

  final baseUrl = 'https://www.cbsl.gov.lk/sites/default/files/cbslweb_documents/statistics/pricerpt/price_report_';
  final hartiBaseUrl = 'https://www.harti.gov.lk/images/download/market_information/';
  final hartiWeeklyBulletinUrl = 'https://www.harti.gov.lk/index.php/en/market-information/weekly-food-commodities-bulletin';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryGreen,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String getWeeklyReportUrl(DateTime date) {
    // Find the Friday for this week's report
    DateTime weekStart = date;

    // Calculate days since the previous Friday
    int daysSinceFriday = (date.weekday - DateTime.friday + 7) % 7;

    // Go back to the Friday that started this week
    weekStart = date.subtract(Duration(days: daysSinceFriday));

    // Find the first Friday of the year
    DateTime firstFriday = DateTime(weekStart.year, 1, 1);
    while (firstFriday.weekday != DateTime.friday) {
      firstFriday = firstFriday.add(const Duration(days: 1));
    }

    // Calculate week number based on Fridays
    int dayDifference = weekStart.difference(firstFriday).inDays;
    int weekNumber = (dayDifference / 7).floor() + 1;

    // Format week number and get year
    final weekNum = weekNumber.toString().padLeft(2, '0');
    final year = weekStart.year.toString();

    // Calculate week end date (Thursday)
    final weekEnd = weekStart.add(const Duration(days: 6));

    // Debug information
    debugPrint('Selected date: ${DateFormat('yyyy-MM-dd').format(date)}');
    debugPrint('Week period: ${DateFormat('yyyy-MM-dd').format(weekStart)} - ${DateFormat('yyyy-MM-dd').format(weekEnd)}');
    debugPrint('Year: $year');
    debugPrint('Week number: $weekNum');

    // Return URL with correct format for HARTI weekly bulletin
    return '$hartiBaseUrl$year/weekly/weekly_${weekNum}_${year}_Eng.pdf';
  }

  Future<void> downloadReport(String type) async {
    try {
      setState(() {
        isDownloading = true;
        errorMessage = null;
      });

      String url;
      if (type == 'daily') {
        final dateStr = DateFormat('yyyyMMdd').format(selectedDate);
        url = '$baseUrl${dateStr}_e.pdf';
        debugPrint('Opening daily report: $url');
      } else {
        url = hartiWeeklyBulletinUrl;
        debugPrint('Opening HARTI weekly bulletin page: $url');
      }

      final uri = Uri.parse(url);
      if (!await canLaunchUrl(uri)) {
        throw Exception('Could not launch $url');
      }

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Opening in browser'),
            backgroundColor: _primaryGreen,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error opening URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to open page. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      body: Container(
        // Same gradient background as HomeTab
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_paleGreen, _lightBg],
            stops: const [0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.05,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title card with enhanced styling
                  _buildAnimatedCard(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors:[
                              Colors.green.shade500,
                              Colors.teal.shade400,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryGreen.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sticky_note_2_outlined,
                            color: _lightText,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'PRICE REPORTS',
                            style: TextStyle(
                              fontSize: isTablet ? 32 : 26,
                              fontWeight: FontWeight.bold,
                              color: _lightText,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Date selector with enhanced styling
                  _buildAnimatedCard(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: _accentGreen.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: _primaryGreen,
                                size: isTablet ? 28 : 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Select Date',
                                style: TextStyle(
                                  fontSize: isTablet ? 26 : 22,
                                  fontWeight: FontWeight.w600,
                                  color: _darkText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Interactive date selector
                          _buildDateSelector(isTablet),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Layout adjustments for tablets/large screens
                  if (isTablet)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildReportCard(
                            title: 'Daily Food Prices',
                            icon: Icons.today,
                            onDownload: () => downloadReport('daily'),
                            source: 'CENTRAL BANK OF SRI LANKA',
                            isTablet: isTablet,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildReportCard(
                            title: 'Weekly Food Prices',
                            icon: Icons.calendar_view_week,
                            onDownload: () => downloadReport('weekly'),
                            source: 'HARTI SRI LANKA',
                            isTablet: isTablet,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildReportCard(
                          title: 'Daily Food Prices',
                          icon: Icons.today,
                          onDownload: () => downloadReport('daily'),
                          source: 'CENTRAL BANK OF SRI LANKA',
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 20),
                        _buildReportCard(
                          title: 'Weekly Food Prices',
                          icon: Icons.calendar_view_week,
                          onDownload: () => downloadReport('weekly'),
                          source: 'HARTI SRI LANKA',
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Interactive date selector with animation
  Widget _buildDateSelector(bool isTablet) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_paleGreen, Colors.white],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: _primaryGreen.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: _primaryGreen.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('dd MMMM yyyy').format(selectedDate),
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w500,
                color: _darkText,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.edit_calendar,
              size: 24,
              color: _primaryGreen,
            ),
          ],
        ),
      ),
    );
  }

  // Animated card wrapper
  Widget _buildAnimatedCard({required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Enhanced interactive report card
  Widget _buildReportCard({
    required String title,
    required IconData icon,
    required VoidCallback onDownload,
    required String source,
    required bool isTablet,
  }) {
    return _buildAnimatedCard(
        child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Title section with icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.green.shade500,
                          Colors.teal.shade400,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryGreen.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: _lightText, size: isTablet ? 28 : 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isTablet ? 22 : 20,
                      fontWeight: FontWeight.bold,
                      color: _darkText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Source information with styling
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: _lightGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.source, size: 18, color: _primaryGreen),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      source,
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        fontWeight: FontWeight.w500,
                        color: _primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Interactive download button
            Center(
              child: _buildDownloadButton(
                onPressed: isDownloading ? null : onDownload,
                isTablet: isTablet,
              ),
            ),

            // Date indicator
            if (title.contains('Daily'))
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'For: ${DateFormat('dd MMM yyyy').format(selectedDate)}',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      fontStyle: FontStyle.italic,
                      color: _darkText.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
          ],
        ),
        ),
    );
  }

  // Enhanced download button with animation
  Widget _buildDownloadButton({
    required VoidCallback? onPressed,
    required bool isTablet,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 30 : 24,
            vertical: isTablet ? 14 : 12,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: onPressed == null
                  ? [Colors.grey.shade300, Colors.grey.shade400]
                  : [
                      Colors.green.shade400,
                      Colors.teal.shade300,
                    ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: onPressed == null
                ? []
                : [
              BoxShadow(
                color: Colors.teal.shade400.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isDownloading
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _lightText,
                ),
              )
                  : Icon(
                Icons.download_rounded,
                color: _lightText,
                size: isTablet ? 24 : 20,
              ),
              const SizedBox(width: 10),
              Text(
                isDownloading ? 'Opening...' : 'Download',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: _lightText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}