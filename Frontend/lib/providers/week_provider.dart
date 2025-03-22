import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekProvider extends ChangeNotifier {
  int _selectedWeek;
  late DateTime _weekStartDate;
  late DateTime _weekEndDate;
  late String _formattedDateRange;

  // Constructor that initializes with the current week number
  WeekProvider() : _selectedWeek = _getCurrentWeekNumber() {
    _calculateDates();
  }

  // Getters for properties
  int get selectedWeek => _selectedWeek;
  DateTime get weekStartDate => _weekStartDate;
  DateTime get weekEndDate => _weekEndDate;
  String get formattedDateRange => _formattedDateRange;

  // Private method to calculate dates based on selected week
  void _calculateDates() {
    final DateTime now = DateTime.now();
    final DateTime firstDayOfYear = DateTime(now.year, 1, 1);

    // Calculate days to add to first day of year (weeks * 7 - 1)
    int daysToAdd = (_selectedWeek - 1) * 7;

    // Handle case where first day of year is not Monday
    final int weekdayOfFirstDay = firstDayOfYear.weekday;
    if (weekdayOfFirstDay > 1) {
      // Adjust days to add to get to Monday of the selected week
      daysToAdd -= (weekdayOfFirstDay - 1);
    }

    // Calculate start date (Monday of the selected week)
    _weekStartDate = firstDayOfYear.add(Duration(days: daysToAdd));

    // Calculate end date (Sunday of the selected week)
    _weekEndDate = _weekStartDate.add(const Duration(days: 6));

    // Format date range for display
    _formattedDateRange =
        '${DateFormat('MMM d').format(_weekStartDate)} - ${DateFormat('MMM d, yyyy').format(_weekEndDate)}';
  }

  // Update the selected week
  void updateWeek(int weekNumber) {
    // Ensure week is between 1 and 52
    int newWeek = weekNumber.clamp(1, 52);
    if (newWeek != _selectedWeek) {
      _selectedWeek = newWeek;
      _calculateDates();
      notifyListeners();
    }
  }

  // Go to previous week
  void previousWeek() {
    if (_selectedWeek > 1) {
      _selectedWeek--;
      _calculateDates();
      notifyListeners();
    }
  }

  // Go to next week
  void nextWeek() {
    if (_selectedWeek < 52) {
      _selectedWeek++;
      _calculateDates();
      notifyListeners();
    }
  }

  // Reset to current week
  void resetToCurrentWeek() {
    final currentWeek = _getCurrentWeekNumber();
    if (_selectedWeek != currentWeek) {
      _selectedWeek = currentWeek;
      _calculateDates();
      notifyListeners();
    }
  }

  // Static helper method to get the current week number (1-52)
  static int _getCurrentWeekNumber() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(firstDayOfYear).inDays;
    return ((dayOfYear / 7) + 1).floor();
  }
}
