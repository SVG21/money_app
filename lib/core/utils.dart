/// Utility function to handle numeric keyboard input updates.
String updateAmount(String currentAmount, String input) {
  String updatedAmount = currentAmount;

  if (input == '<') {
    if (updatedAmount.isNotEmpty) {
      updatedAmount = updatedAmount.substring(0, updatedAmount.length - 1);
    }
    if (updatedAmount.isEmpty) {
      updatedAmount = '0.00';
    }
  } else if (input == '.') {
    if (!updatedAmount.contains('.')) {
      updatedAmount += '.';
    }
  } else {
    if (updatedAmount == '0.00' || updatedAmount == '0') {
      updatedAmount = input;
    } else {
      updatedAmount += input;
    }
  }

  return updatedAmount;
}

/// Utility function to format a DateTime object to a human-readable string.
String formatDate(DateTime date) {
  final today = DateTime.now();
  final yesterday = DateTime.now().subtract(const Duration(days: 1));

  if (date.year == today.year &&
      date.month == today.month &&
      date.day == today.day) {
    return 'TODAY';
  } else if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return 'YESTERDAY';
  } else {
    return '${date.day} ${monthName(date.month)}';
  }
}

/// Utility function to get the month name from its number.
String monthName(int month) {
  const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return monthNames[month - 1];
}
