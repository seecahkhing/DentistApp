import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_theme.dart';
import '../../../core/widgets/booking_card.dart';
import '../view_models/bookings_view_model.dart';

class CalendarBookingsView extends StatelessWidget {
  const CalendarBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingsViewModel>();
    final format = vm.period == PeriodFilter.week
        ? CalendarFormat.week
        : CalendarFormat.month; // month + year filters use month grid

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2035, 12, 31),
          focusedDay: vm.focusedDay,
          selectedDayPredicate: (day) => isSameDay(vm.selectedDay, day),
          calendarFormat: format,
          availableCalendarFormats: {format: format.name},
          headerVisible: false,
          startingDayOfWeek: StartingDayOfWeek.monday,
          eventLoader: vm.bookingsOn,
          onDaySelected: (selected, focused) => vm.setFocusedDay(focused),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppTheme.teal.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: AppTheme.teal,
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: AppTheme.teal,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: vm.bookingsOn(vm.selectedDay).isEmpty
              ? Center(
                  child: Text(
                    'No bookings this day',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
                  itemCount: vm.bookingsOn(vm.selectedDay).length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final booking = vm.bookingsOn(vm.selectedDay)[index];
                    return BookingCard(
                      booking: booking,
                      onTap: () => context.push('/bookings/${booking.id}'),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
