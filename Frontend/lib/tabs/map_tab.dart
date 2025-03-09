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
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF004D2A), // Dark green color
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
          const SnackBar(
            content: Text('Opening in browser'),
            backgroundColor: Colors.green,
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
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF004D2A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'PRICE REPORTS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'select date',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('dd/MM/yyyy').format(selectedDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.calendar_today, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSection(
                title: 'Dayly Food Prices',
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
        color: const Color(0xFF004D2A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: isDownloading ? null : onDownload,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            icon: const Icon(Icons.download, color: Colors.black),
            label: Text(
              'Download',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Source',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
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
                    color: Colors.green[700],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    source,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
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