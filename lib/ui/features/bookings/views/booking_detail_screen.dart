import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/booking.dart';
import '../../../core/app_theme.dart';
import '../view_models/bookings_view_model.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final int bookingId;

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingsViewModel>().byId(bookingId);

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking')),
        body: const Center(child: Text('Booking not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(booking.fullName),
        actions: [
          IconButton(
            tooltip: 'Edit',
            onPressed: () => context.push('/bookings/${booking.id}/edit'),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context, booking),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          _Hero(booking: booking),
          const SizedBox(height: 16),
          _Row(label: 'Address', value: booking.address),
          _Row(label: 'Mobile', value: booking.mobileNumber),
          _Row(label: 'When', value: formatDateTime(booking.scheduledAt)),
          _Row(label: 'Price', value: formatMoney(booking.price)),
          _Row(
            label: 'Insurance',
            value: booking.hasInsurance
                ? (booking.insuranceName ?? 'Yes')
                : 'No',
          ),
          _Row(
            label: 'Reminder',
            value: booking.reminderAt == null
                ? 'None'
                : formatDateTime(booking.reminderAt!),
          ),
          const SizedBox(height: 20),
          const Text(
            'Status',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final status in BookingStatus.values)
                ChoiceChip(
                  label: Text(status.label),
                  selected: booking.status == status,
                  selectedColor: AppTheme.chipColorsForStatus(status).background,
                  labelStyle: TextStyle(
                    color: booking.status == status
                        ? AppTheme.chipColorsForStatus(status).foreground
                        : AppTheme.muted,
                    fontWeight: booking.status == status
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                  side: status == BookingStatus.cancelled
                      ? BorderSide(
                          color: AppTheme.cancelled.withValues(alpha: 0.35),
                        )
                      : null,
                  onSelected: (_) {
                    context.read<BookingsViewModel>().setStatus(
                      booking.id,
                      status,
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Booking booking) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete booking?'),
        content: Text("Remove ${booking.fullName}'s appointment."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await context.read<BookingsViewModel>().delete(booking.id);
    if (context.mounted) context.go('/');
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final cancelled = booking.status == BookingStatus.cancelled;
    final accent = AppTheme.accentForStatus(booking.status);

    return Card(
      color: cancelled ? AppTheme.cancelledSurface : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.fullName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.4,
                decoration: cancelled ? TextDecoration.lineThrough : null,
                decorationColor: AppTheme.cancelled.withValues(alpha: 0.45),
                color: cancelled
                    ? AppTheme.cancelled.withValues(alpha: 0.95)
                    : AppTheme.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${booking.status.label} · ${formatDate(booking.scheduledAt)}',
              style: TextStyle(
                color: cancelled
                    ? AppTheme.cancelled
                    : Colors.black.withValues(alpha: 0.55),
                fontWeight: cancelled ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (cancelled) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'This appointment was cancelled',
                  style: TextStyle(
                    color: AppTheme.cancelled,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: TextStyle(color: Colors.black.withValues(alpha: 0.45)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
