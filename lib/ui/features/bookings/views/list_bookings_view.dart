import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/booking.dart';
import '../../../core/widgets/booking_card.dart';
import '../view_models/bookings_view_model.dart';

class ListBookingsView extends StatelessWidget {
  const ListBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingsViewModel>();
    final bookings = vm.bookingsInRange;

    if (bookings.isEmpty) {
      return Center(
        child: Text(
          'No bookings in this ${vm.period == PeriodFilter.week ? 'week' : 'month'}',
          style: TextStyle(color: Colors.black.withValues(alpha: 0.45)),
        ),
      );
    }

    final groups = <DateTime, List<Booking>>{};
    for (final booking in bookings) {
      final key = DateTime(
        booking.scheduledAt.year,
        booking.scheduledAt.month,
        booking.scheduledAt.day,
      );
      groups.putIfAbsent(key, () => []).add(booking);
    }
    final days = groups.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final items = groups[day]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
              child: Text(
                DateFormat.EEEE().add_MMMd().format(day),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withValues(alpha: 0.55),
                ),
              ),
            ),
            for (final booking in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: BookingCard(
                  booking: booking,
                  onTap: () => context.push('/bookings/${booking.id}'),
                ),
              ),
          ],
        );
      },
    );
  }
}
