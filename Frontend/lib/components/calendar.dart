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

class _CalendarState extends State<Calendar> {
  // Calendar state variables
  late DateTime _currentWeekStart;
  late DateTime _currentWeekEnd;
  late List<DateTime> _weekDays;
  final int _totalWeeks = 52;

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
  void initState() {
    super.initState();
    _initializeCalendar();
  }

  void _initializeCalendar() {
    // Initialize with current week
    final now = DateTime.now();

    // Find the start of the current week (Monday)
    _currentWeekStart = now.subtract(Duration(days: now.weekday - 1));

    // Find the end of the current week (Sunday)
    _currentWeekEnd = _currentWeekStart.add(const Duration(days: 6));

    _updateWeekDays();
  }

  void _updateWeekDays() {
    _weekDays = List.generate(
        7, (index) => _currentWeekStart.add(Duration(days: index)));
    _currentWeekEnd = _weekDays.last;
  }

  void _goToPreviousWeek() {
    // Use WeekProvider to change the week
    final weekProvider = Provider.of<WeekProvider>(context, listen: false);
    weekProvider.previousWeek();

    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
      _updateWeekDays();
    });
  }

  void _goToNextWeek() {
    // Use WeekProvider to change the week
    final weekProvider = Provider.of<WeekProvider>(context, listen: false);
    weekProvider.nextWeek();

    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
      _updateWeekDays();
    });
  }

  void _goToCurrentWeek() {
    // Use WeekProvider to reset to the current week
    final weekProvider = Provider.of<WeekProvider>(context, listen: false);
    weekProvider.resetToCurrentWeek();

    setState(() {
      final now = DateTime.now();
      _currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
      _updateWeekDays();
    });

    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Calendar reset to current week',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _primaryGreen,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool _isCurrentWeek() {
    final now = DateTime.now();
    final currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    return _currentWeekStart.year == currentWeekStart.year &&
        _currentWeekStart.month == currentWeekStart.month &&
        _currentWeekStart.day == currentWeekStart.day;
  }

  // Check if the given day is today
  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    // Get the selected week from the provider
    final weekProvider = Provider.of<WeekProvider>(context);
    final selectedWeek = weekProvider.selectedWeek;

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
              "Here's the insights for : ${DateFormat('d MMM').format(_currentWeekStart)} - ${DateFormat('d MMM yyyy').format(_currentWeekEnd)}",
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
              "Use the toggles above to change the week.",
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
                borderRadius: BorderRadius.circular(40),
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
                    onPressed: _goToPreviousWeek,
                  ),

                  // Week text
                  Text(
                    'Week $selectedWeek of $_totalWeeks',
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
                    onPressed: _goToNextWeek,
                  ),
                ],
              ),
            ),
          ),

          // Reset button (only visible when not on current week)
          if (!_isCurrentWeek())
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnimatedOpacity(
                opacity: _isCurrentWeek() ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: ElevatedButton.icon(
                  onPressed: _goToCurrentWeek,
                  icon: const Icon(Icons.today, size: 16),
                  label: const Text('Reset to Current Week'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _resetButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
