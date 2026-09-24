import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../domain/models/booking.dart';
import '../../../core/app_theme.dart';
import '../view_models/bookings_view_model.dart';
import 'calendar_bookings_view.dart';
import 'kanban_bookings_view.dart';
import 'list_bookings_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingsViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Bookings'),
        actions: [
          _ViewModeToggle(
            mode: vm.viewMode,
            onChanged: vm.setViewMode,
          ),
          IconButton(
            tooltip: 'Filter period',
            onPressed: () => _showPeriodFilter(context, vm),
            icon: Badge(
              isLabelVisible: vm.period != PeriodFilter.month,
              smallSize: 8,
              child: const Icon(Icons.tune_rounded, size: 22),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/bookings/new'),
        icon: const Icon(Icons.add, size: 20),
        label: const Text('New'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PeriodNavigator(
            label: vm.rangeLabel,
            periodLabel: vm.period.label,
            onPrevious: () => vm.shiftRange(-1),
            onNext: () => vm.shiftRange(1),
            onReset: () => vm.setFocusedDay(DateTime.now()),
          ),
          if (vm.upcomingReminders.isNotEmpty)
            _RemindersBanner(bookings: vm.upcomingReminders),
          Expanded(
            child: vm.loading
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : vm.error != null
                ? Center(
                    child: Text(
                      vm.error!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  )
                : switch (vm.viewMode) {
                    BookingViewMode.calendar => const CalendarBookingsView(),
                    BookingViewMode.kanban => const KanbanBookingsView(),
                    BookingViewMode.list => const ListBookingsView(),
                  },
          ),
        ],
      ),
    );
  }

  Future<void> _showPeriodFilter(
    BuildContext context,
    BookingsViewModel vm,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Time range',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),
              ...PeriodFilter.values.map((period) {
                final selected = vm.period == period;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: selected
                            ? AppTheme.teal
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                    ),
                    tileColor: selected
                        ? AppTheme.teal.withValues(alpha: 0.06)
                        : AppTheme.surface,
                    leading: Icon(
                      switch (period) {
                        PeriodFilter.week => Icons.view_week_outlined,
                        PeriodFilter.month => Icons.calendar_view_month_outlined,
                        PeriodFilter.year => Icons.calendar_today_outlined,
                      },
                      color: selected ? AppTheme.teal : AppTheme.muted,
                    ),
                    title: Text(period.label),
                    trailing: selected
                        ? const Icon(Icons.check, color: AppTheme.teal, size: 20)
                        : null,
                    onTap: () {
                      vm.setPeriod(period);
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModeToggle extends StatelessWidget {
  const _ViewModeToggle({
    required this.mode,
    required this.onChanged,
  });

  final BookingViewMode mode;
  final ValueChanged<BookingViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ViewIcon(
                tooltip: 'List',
                icon: Icons.format_list_bulleted_rounded,
                selected: mode == BookingViewMode.list,
                onTap: () => onChanged(BookingViewMode.list),
              ),
              _ViewIcon(
                tooltip: 'Calendar',
                icon: Icons.calendar_month_rounded,
                selected: mode == BookingViewMode.calendar,
                onTap: () => onChanged(BookingViewMode.calendar),
              ),
              _ViewIcon(
                tooltip: 'Kanban',
                icon: Icons.view_kanban_rounded,
                selected: mode == BookingViewMode.kanban,
                onTap: () => onChanged(BookingViewMode.kanban),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewIcon extends StatelessWidget {
  const _ViewIcon({
    required this.tooltip,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      elevation: selected ? 0.5 : 0,
      shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 18,
              color: selected ? AppTheme.teal : AppTheme.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class _PeriodNavigator extends StatelessWidget {
  const _PeriodNavigator({
    required this.label,
    required this.periodLabel,
    required this.onPrevious,
    required this.onNext,
    required this.onReset,
  });

  final String label;
  final String periodLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  periodLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(alpha: 0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
          TextButton(
            onPressed: onReset,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: AppTheme.teal,
            ),
            child: const Text('Today'),
          ),
        ],
      ),
    );
  }
}

class _RemindersBanner extends StatelessWidget {
  const _RemindersBanner({required this.bookings});

  final List<Booking> bookings;

  @override
  Widget build(BuildContext context) {
    final first = bookings.first;
    final extra = bookings.length - 1;
    final overdue = first.reminderAt != null &&
        first.reminderAt!.isBefore(DateTime.now());

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Material(
        color: overdue
            ? const Color(0xFFFFF7ED)
            : AppTheme.teal.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.push('/bookings/${first.id}'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                Icon(
                  overdue
                      ? Icons.notification_important_outlined
                      : Icons.alarm_outlined,
                  color: overdue ? const Color(0xFFC2410C) : AppTheme.teal,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    overdue
                        ? 'Reminder due · ${first.fullName}'
                        : 'Upcoming · ${first.fullName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (extra > 0)
                  Text(
                    '+$extra',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool isSameDaySafe(DateTime a, DateTime b) => isSameDay(a, b);
