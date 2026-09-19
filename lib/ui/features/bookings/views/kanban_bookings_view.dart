import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/booking.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/booking_card.dart';
import '../view_models/bookings_view_model.dart';

class KanbanBookingsView extends StatelessWidget {
  const KanbanBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final columns = BookingStatus.values
            .map((status) => _KanbanColumn(status: status, compact: !wide))
            .toList();

        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final column in columns) Expanded(child: column),
            ],
          );
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
          itemCount: columns.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) => SizedBox(
            width: 280,
            child: columns[index],
          ),
        );
      },
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  const _KanbanColumn({required this.status, required this.compact});

  final BookingStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingsViewModel>();
    final items = vm.byStatus(status);

    return DragTarget<Booking>(
      onWillAcceptWithDetails: (details) => details.data.status != status,
      onAcceptWithDetails: (details) => vm.setStatus(details.data.id, status),
      builder: (context, candidate, rejected) {
        final highlight = candidate.isNotEmpty;
        return Container(
          margin: compact
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(8, 12, 8, 88),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: highlight
                ? AppTheme.teal.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlight
                  ? AppTheme.teal
                  : Colors.black.withValues(alpha: 0.06),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 10),
                child: Row(
                  children: [
                    Text(
                      status.label,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Text(
                      '${items.length}',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'Drop here',
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.3),
                            fontSize: 12,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final booking = items[index];
                          final card = BookingCard(
                            booking: booking,
                            onTap: () =>
                                context.push('/bookings/${booking.id}'),
                            trailing: compact || !kIsWeb
                                ? PopupMenuButton<BookingStatus>(
                                    tooltip: 'Move',
                                    onSelected: (value) =>
                                        vm.setStatus(booking.id, value),
                                    itemBuilder: (context) => [
                                      for (final s in BookingStatus.values)
                                        if (s != booking.status)
                                          PopupMenuItem(
                                            value: s,
                                            child: Text('Move to ${s.label}'),
                                          ),
                                    ],
                                  )
                                : null,
                          );
                          return LongPressDraggable<Booking>(
                            data: booking,
                            feedback: Material(
                              elevation: 6,
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(width: 260, child: card),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.35,
                              child: card,
                            ),
                            child: card,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
