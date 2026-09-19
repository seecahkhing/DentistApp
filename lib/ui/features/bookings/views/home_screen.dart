import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../domain/models/booking.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/booking_card.dart';
import '../view_models/bookings_view_model.dart';
import 'calendar_bookings_view.dart';
import 'kanban_bookings_view.dart';
import 'list_bookings_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dental Booking'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/bookings/new'),
        tooltip: 'New booking',
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Column(
              children: [
                SegmentedButton<PeriodFilter>(
                  segments: const [
                    ButtonSegment(
                      value: PeriodFilter.week,
                      label: Text('Week'),
                    ),
                    ButtonSegment(
                      value: PeriodFilter.month,
                      label: Text('Month'),
                    ),
                  ],
                  selected: {vm.period},
                  onSelectionChanged: (value) => vm.setPeriod(value.first),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => vm.shiftRange(-1),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Text(
                        vm.rangeLabel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => vm.shiftRange(1),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                SegmentedButton<BookingViewMode>(
                  segments: const [
                    ButtonSegment(
                      value: BookingViewMode.calendar,
                      icon: Icon(Icons.calendar_month_outlined, size: 18),
                      label: Text('Calendar'),
                    ),
                    ButtonSegment(
                      value: BookingViewMode.kanban,
                      icon: Icon(Icons.view_kanban_outlined, size: 18),
                      label: Text('Kanban'),
                    ),
                    ButtonSegment(
                      value: BookingViewMode.list,
                      icon: Icon(Icons.view_agenda_outlined, size: 18),
                      label: Text('List'),
                    ),
                  ],
                  selected: {vm.viewMode},
                  onSelectionChanged: (value) => vm.setViewMode(value.first),
                ),
              ],
            ),
          ),
          if (vm.upcomingReminders.isNotEmpty)
            _RemindersBanner(bookings: vm.upcomingReminders),
          Expanded(
            child: vm.loading
                ? const Center(child: CircularProgressIndicator())
                : vm.error != null
                ? Center(child: Text(vm.error!))
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Material(
        color: overdue
            ? const Color(0xFFFFF1E8)
            : AppTheme.teal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push('/bookings/${first.id}'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  overdue ? Icons.notification_important_outlined : Icons.alarm,
                  color: overdue ? const Color(0xFFB45309) : AppTheme.teal,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    overdue
                        ? 'Reminder due: ${first.fullName}'
                        : 'Upcoming reminder: ${first.fullName}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                if (extra > 0)
                  Text(
                    '+$extra',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.5),
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
