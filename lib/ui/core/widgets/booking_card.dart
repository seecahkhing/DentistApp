import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/booking.dart';
import '../../core/app_theme.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.trailing,
  });

  final Booking booking;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat.MMMd().format(booking.scheduledAt)} · ${formatTime(booking.scheduledAt)}',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.55),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _Chip(booking.status.label),
                        if (booking.price != null)
                          _Chip(formatMoney(booking.price)),
                        if (booking.hasInsurance)
                          _Chip(booking.insuranceName ?? 'Insured'),
                        if (booking.reminderAt != null) const _Chip('Reminder'),
                      ],
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.teal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppTheme.teal,
        ),
      ),
    );
  }
}
