import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/week_provider.dart';

class Calendar extends StatefulWidget {
  final EdgeInsetsGeometry margin;

  const Calendar({
    super.key,
    this.margin = const EdgeInsets.all(16),
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>
    with AutomaticKeepAliveClientMixin {
  // Calendar colors
  final Color _calendarBg = Colors.white;
  final Color _selectedDayBg = Colors.green.shade500;
  final Color _todayBg = Colors.greenAccent.shade100;
  final Color _dayTextColor = Colors.black87;
  final Color _selectedDayTextColor = Colors.white;
  final Color _weekdayTextColor = Colors.grey.shade700;
  final Color _navigationIconColor = Colors.green.shade700;
  final Color _resetButtonColor = Colors.green.shade500;
  final Color _primaryGreen = const Color(0xFF1B5E20); // Dark green

  @override
  bool get wantKeepAlive => true;

  // Check if the current selected week is the current week
  bool _isCurrentWeek(WeekProvider provider) {
    final currentWeek = _getCurrentWeekNumber();
    return provider.selectedWeek == currentWeek;
  }

  // Helper method to get the current week number (1-52)
  int _getCurrentWeekNumber() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(firstDayOfYear).inDays;
    return ((dayOfYear / 7) + 1).floor();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Get screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    // Get the week provider
    final weekProvider = Provider.of<WeekProvider>(context);
    final selectedWeek = weekProvider.selectedWeek;
    final dateRange = weekProvider.formattedDateRange;
    final totalWeeks = 52;

    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: _calendarBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header text showing the date range
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text(
              "Here's the insights for: $dateRange",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Subheader text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Use the toggles below to change the week.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),

          // Week selector with navigation
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 32,
                    ),
                    onPressed: () => weekProvider.previousWeek(),
                  ),

                  // Week text
                  Text(
                    'Week $selectedWeek of $totalWeeks',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Forward button
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_right,
                      size: 32,
                    ),
                    onPressed: () => weekProvider.nextWeek(),
                  ),
                ],
              ),
            ),
          ),

          // Reset button (only visible when not on current week)
          if (!_isCurrentWeek(weekProvider))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnimatedOpacity(
                opacity: _isCurrentWeek(weekProvider) ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: ElevatedButton.icon(
                  onPressed: () => weekProvider.resetToCurrentWeek(),
                  icon: const Icon(Icons.today, size: 16),
                  label: const Text('Back to Current Week'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _resetButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
