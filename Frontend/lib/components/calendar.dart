import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  late List<DateTime> _weekDays;

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
    // Find the start of the current week (Sunday or Monday depending on locale)
    _currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    if (_currentWeekStart.day > now.day) {
      // If we went to previous month, adjust
      _currentWeekStart = now.subtract(Duration(days: now.weekday + 6));
    }
    _updateWeekDays();
  }

  void _updateWeekDays() {
    _weekDays = List.generate(7, (index) =>
        _currentWeekStart.add(Duration(days: index))
    );
  }

  void _goToPreviousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
      _updateWeekDays();
    });
  }

  void _goToNextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
      _updateWeekDays();
    });
  }

  void _goToCurrentWeek() {
    setState(() {
      final now = DateTime.now();
      _currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
      if (_currentWeekStart.day > now.day) {
        _currentWeekStart = now.subtract(Duration(days: now.weekday + 6));
      }
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
    if (currentWeekStart.day > now.day) {
      // If we went to previous month, adjust
      return _currentWeekStart.year == now.year &&
          _currentWeekStart.month == now.month &&
          _currentWeekStart.day == now.subtract(Duration(days: now.weekday + 6)).day;
    }
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
          // Calendar header with week range and navigation
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: _navigationIconColor,
                    size: 28,
                  ),
                  onPressed: _goToPreviousWeek,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

                // Week range text with border
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${DateFormat('d MMM').format(_weekDays.first)} - ${DateFormat('d MMM').format(_weekDays.last)} ${DateFormat('yyyy').format(_weekDays.last)}',
                    style: TextStyle(
                      color: _primaryGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen ? 13 : 14,
                    ),
                  ),
                ),

                // Forward button
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: _navigationIconColor,
                    size: 28,
                  ),
                  onPressed: _goToNextWeek,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
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