// lib/core/utils/debug_print.dart
//
// Global debug print utility
// Allows enabling/disabling debug prints throughout the application
//

/// Global flag to control debug printing
/// Set to false in production to disable all debug prints
const bool PRINT_DEBUG = true;

String _debugTimestamp() {
  final now = DateTime.now();
  final year = now.year.toString().padLeft(4, '0');
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  final hour = now.hour.toString().padLeft(2, '0');
  final minute = now.minute.toString().padLeft(2, '0');
  final second = now.second.toString().padLeft(2, '0');
  final ms = now.millisecond.toString().padLeft(3, '0');
  return '$year-$month-$day $hour:$minute:$second.$ms';
}

/// Debug print function that only prints if PRINT_DEBUG is true
/// Use this instead of regular print() throughout the application
void logDebug(Object? object) {
  if (PRINT_DEBUG) {
    // ignore: avoid_print
    print('[${_debugTimestamp()}] $object');
  }
}

/// Debug print with a prefix for categorization
void logDebugWithPrefix(String prefix, Object? object) {
  if (PRINT_DEBUG) {
    // ignore: avoid_print
    print('[${_debugTimestamp()}][$prefix] $object');
  }
}

