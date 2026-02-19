import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:fasting_app/app/app.dart';
import 'package:logging/logging.dart';

/// A centralized logger for the application
abstract class AppLogger {
  /// Initializes the logger with the specified [level] 
  /// or defaults based on the build mode
  static void initialize({Level? level}) {
    // Configure the root logger
    // In release mode, log only warnings and above; in debug mode, log info and above
    Logger.root.level = level ?? (kReleaseMode ? Level.WARNING : Level.INFO);
    Logger.root.onRecord.listen(_printLogRecord);

    // Connect the bloc observer for logging Bloc events, transitions, and errors
    Bloc.observer = AppBlocLoggingObserver();
  }

  /// Prints the actual log record to the console
  static void _printLogRecord(LogRecord record) {
    // ignore: avoid_print
    print('[${record.level.name}] [${record.loggerName}] ${record.message}');
  }
}
