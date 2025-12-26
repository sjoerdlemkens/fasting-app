import 'package:flutter/material.dart';
import 'package:fasting_app/app/theme/app_spacing.dart';

/// A generic calendar widget that displays a month view with customizable day widgets.
///
/// This widget provides the basic calendar layout and navigation, while allowing
/// complete customization of what gets displayed for each day through the [dayBuilder].
class BaseCalendar extends StatelessWidget {
  /// The month to display (any date within the desired month)
  final DateTime currentMonth;

  /// Builder function that creates the widget for each day
  final Widget Function(DateTime date, bool isCurrentMonth, bool isToday)
      dayBuilder;

  /// Callback when the previous month button is pressed
  final VoidCallback? onPreviousMonth;

  /// Callback when the next month button is pressed
  final VoidCallback? onNextMonth;

  /// Custom header widget. If null, uses the default month/year header
  final Widget? header;

  /// Whether to show the weekday labels (Mon, Tue, Wed, etc.)
  final bool showWeekdayLabels;

  /// Custom weekday labels. If null, uses default ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
  final List<String>? weekdayLabels;

  /// Padding around the calendar
  final EdgeInsetsGeometry padding;

  /// Spacing between calendar cells
  final double cellSpacing;

  const BaseCalendar({
    super.key,
    required this.currentMonth,
    required this.dayBuilder,
    this.onPreviousMonth,
    this.onNextMonth,
    this.header,
    this.showWeekdayLabels = true,
    this.weekdayLabels,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    this.cellSpacing = 4,
  });

  /// Gets all the days that should be displayed in the calendar grid
  List<DateTime> get _calendarDays {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);

    // Start from Monday of the week containing the first day
    final startDate = firstDayOfMonth.subtract(
      Duration(days: (firstDayOfMonth.weekday - 1) % 7),
    );

    // End on Sunday of the week containing the last day
    final endDate = lastDayOfMonth.add(
      Duration(days: (7 - lastDayOfMonth.weekday) % 7),
    );

    final days = <DateTime>[];
    DateTime current = startDate;

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  /// Gets the formatted month and year string
  String get _monthYearText {
    final months = [
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
    return '${months[currentMonth.month - 1]} ${currentMonth.year}';
  }

  /// Checks if the given date is today
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Checks if the given date is in the current month being displayed
  bool _isCurrentMonth(DateTime date) {
    return date.month == currentMonth.month && date.year == currentMonth.year;
  }

  /// Builds the default header with month navigation
  Widget _buildDefaultHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPreviousMonth,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            _monthYearText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: onNextMonth,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  /// Builds the weekday labels row
  Widget _buildWeekdayLabels() {
    final labels =
        weekdayLabels ?? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Padding(
      padding: padding,
      child: Row(
        children: labels
            .map((day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final calendarDays = _calendarDays;

    return Column(
      children: [
        // Header
        header ?? _buildDefaultHeader(),

        // Weekday labels
        if (showWeekdayLabels) _buildWeekdayLabels(),

        if (showWeekdayLabels) const SizedBox(height: AppSpacing.sm),

        // Calendar grid
        Expanded(
          child: Padding(
            padding: padding,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                crossAxisSpacing: cellSpacing,
                mainAxisSpacing: cellSpacing,
              ),
              itemCount: calendarDays.length,
              itemBuilder: (context, index) {
                final date = calendarDays[index];
                return dayBuilder(
                  date,
                  _isCurrentMonth(date),
                  _isToday(date),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
