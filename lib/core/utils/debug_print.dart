// lib/core/utils/debug_print.dart
//
// Global debug print utility
// Allows enabling/disabling debug prints throughout the application
//

/// Global flag to control debug printing
/// Set to false in production to disable all debug prints
const bool PRINT_DEBUG = true;

/// Debug print function that only prints if PRINT_DEBUG is true
/// Use this instead of regular print() throughout the application
void logDebug(Object? object) {
  if (PRINT_DEBUG) {
    // ignore: avoid_print
    print(object);
  }
}

/// Debug print with a prefix for categorization
void logDebugWithPrefix(String prefix, Object? object) {
  if (PRINT_DEBUG) {
    // ignore: avoid_print
    print('[$prefix] $object');
  }
}

