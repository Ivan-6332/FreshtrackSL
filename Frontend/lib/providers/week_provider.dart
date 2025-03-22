import 'package:flutter/material.dart';

class WeekProvider extends ChangeNotifier {
  int _selectedWeek;

  // Constructor that initializes with the current week number
  WeekProvider() : _selectedWeek = _getCurrentWeekNumber();

  int get selectedWeek => _selectedWeek;

  // Update the selected week
  void updateWeek(int weekNumber) {
    // Ensure week is between 1 and 52
    int newWeek = weekNumber.clamp(1, 52);
    if (newWeek != _selectedWeek) {
      _selectedWeek = newWeek;
      notifyListeners();
    }
  }

  // Go to previous week
  void previousWeek() {
    if (_selectedWeek > 1) {
      _selectedWeek--;
      notifyListeners();
    }
  }

  // Go to next week
  void nextWeek() {
    if (_selectedWeek < 52) {
      _selectedWeek++;
      notifyListeners();
    }
  }

  // Reset to current week
  void resetToCurrentWeek() {
    final currentWeek = _getCurrentWeekNumber();
    if (_selectedWeek != currentWeek) {
      _selectedWeek = currentWeek;
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
