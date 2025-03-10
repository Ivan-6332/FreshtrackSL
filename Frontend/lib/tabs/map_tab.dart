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

  // Enhanced color palette - matching with ExploreTab
  final Color _primaryGreen = const Color(0xFF4CAF50); // Main green
  final Color _accentGreen = const Color(0xFF81C784); // Secondary green
  final Color _paleGreen = const Color(0xFFE8F5E9); // Background green
  final Color _darkText = const Color(0xFF212121); // Near black for text
  final Color _lightBg = const Color(0xFFFAFAFA); // Off-white background
  final Color _darkGreen = const Color(0xFF004D2A); // Keeping the dark green for sections
  final Color _lightGreen = const Color(0xFFE8F5E9); // Very light green for buttons

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
              primary: _primaryGreen, // Updated to match ExploreTab
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
    print('MapTab is building');
    return Scaffold(
      body: Container(
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryGreen.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'PRICE REPORTS',
                      style: TextStyle(
                        fontSize: 28, // Increased size
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Changed to black
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryGreen.withOpacity(0.12),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 24, // Increased size
                            fontWeight: FontWeight.w500,
                            color: Colors.black, // Changed to black
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: _accentGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _primaryGreen.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy').format(selectedDate),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _darkText,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.calendar_today, size: 20, color: Colors.black), // Changed to black
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    title: 'Daily Food Prices',
                    onDownload: () => downloadReport('daily'),
                    source: 'CENTRAL BANK OF SRI LANKA',
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    title: 'Weekly Food Prices',
                    onDownload: () => downloadReport('weekly'),
                    source: 'HARTI SRI LANKA',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required VoidCallback onDownload,
    required String source,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Changed to off-white
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryGreen.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: _accentGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: _primaryGreen.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22, // Increased size
                fontWeight: FontWeight.bold,
                color: Colors.black, // Changed to black
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: isDownloading ? null : onDownload,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, // Transparent background
              foregroundColor: _primaryGreen, // Green text
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: _primaryGreen, width: 1.5),
              ),
              elevation: 0, // Remove shadow
            ),
            icon: Icon(Icons.download, color: _primaryGreen),
            label: Text(
              'Download',
              style: TextStyle(
                fontSize: 16,
                color: _primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Source',
                style: TextStyle(
                  fontSize: 16, // Increased size
                  fontWeight: FontWeight.w500,
                  color: _darkText,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _lightGreen, // Changed to light green
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryGreen.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    source,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Changed to black
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}