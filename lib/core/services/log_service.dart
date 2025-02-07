import 'package:logger/logger.dart';

enum LogLevel {
  trace, // Most Detailed, VERBOSE level (ex. click coordinates)
  debug,
  // Detailed Information
  // Examples: API request/response data, state changes, user interactions
  info,
  // General information: (Normal Operational Messages, Important business events
  // Exampes: successful login, payment completion, profile updates
  warning,
  // Potential Issues: Potential problems or exceptional situations
  // Examples: API retires, network delays, low disk space
  error,
  // Serious Problem: Actual errors or serious issues
  // Examples: API failures, payment failures, crashes
  fatal,
  // Critical Error: System is unusable
  // Examples: System crashes, database corruption
}

class LogService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis:
          true, // Print an emoji for each log message  // Should each log print contain a timestamp
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
  );

  LogService._();

  static void trace(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void fatal(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
