class DatesUtils {

  // Check if the two dates are the same day
  // @param date1 the first date
  // @param date2 the second date
  // @return true if the two dates are the same day, false otherwise
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Check if the two dates are tomorrow
  // @param date1 the first date
  // @param date2 the second date
  // @return true if the two dates are tomorrow, false otherwise
  static bool isTomorrow(DateTime date1, DateTime date2) {
    final tomorrow = date2.add(const Duration(days: 1));
    return isSameDay(date1, tomorrow);
  }

  // Check if the two dates are in the same week
  // @param date1 the first date
  // @param date2 the second date
  // @return true if the two dates are in the same week, false otherwise
  static bool isSameWeek(DateTime date1, DateTime date2) {
    final startOfWeek = date2.subtract(Duration(days: date2.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date1.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
        date1.isBefore(endOfWeek.add(const Duration(seconds: 1)));
  }
}