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
    final cancelled = booking.status == BookingStatus.cancelled;
    final accent = AppTheme.accentForStatus(booking.status);

    return Card(
      clipBehavior: Clip.antiAlias,
      color: cancelled ? AppTheme.cancelledSurface : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 3, color: accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat.jm().format(booking.scheduledAt),
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              letterSpacing: -0.2,
                              color: cancelled
                                  ? AppTheme.cancelled
                                  : AppTheme.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat.MMMd().format(booking.scheduledAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: cancelled
                                  ? AppTheme.cancelled.withValues(alpha: 0.65)
                                  : AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.fullName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                letterSpacing: -0.25,
                                decoration: cancelled
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: AppTheme.cancelled.withValues(
                                  alpha: 0.5,
                                ),
                                color: cancelled
                                    ? AppTheme.cancelled.withValues(alpha: 0.9)
                                    : AppTheme.ink,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                _StatusChip(status: booking.status),
                                if (booking.price != null)
                                  _Chip(formatMoney(booking.price)),
                                if (booking.hasInsurance)
                                  _Chip(booking.insuranceName ?? 'Insured'),
                                if (booking.reminderAt != null)
                                  const _Chip('Reminder'),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.chipColorsForStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: colors.foreground,
          letterSpacing: 0.1,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppTheme.muted,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
