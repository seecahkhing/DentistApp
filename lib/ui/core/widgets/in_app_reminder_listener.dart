import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/booking.dart';
import '../../../routing/app_router.dart';
import '../app_theme.dart';
import '../../features/bookings/view_models/bookings_view_model.dart';

/// Surfaces due booking reminders while the app is open (all platforms).
class InAppReminderListener extends StatefulWidget {
  const InAppReminderListener({super.key, required this.child});

  final Widget child;

  @override
  State<InAppReminderListener> createState() => _InAppReminderListenerState();
}

class _InAppReminderListenerState extends State<InAppReminderListener> {
  Timer? _timer;
  final _acknowledged = <String>{};

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _poll());
    WidgetsBinding.instance.addPostFrameCallback((_) => _poll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _poll() {
    final vm = context.read<BookingsViewModel>();
    for (final booking in vm.dueReminders) {
      final key = _reminderKey(booking);
      if (_acknowledged.contains(key)) continue;
      _acknowledged.add(key);
      unawaited(_showReminder(booking));
    }
  }

  String _reminderKey(Booking booking) =>
      '${booking.id}-${booking.reminderAt!.millisecondsSinceEpoch}';

  Future<void> _showReminder(Booking booking) async {
    final navContext = rootNavigatorKey.currentContext;
    if (navContext == null || !navContext.mounted) return;

    await showDialog<void>(
      context: navContext,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.alarm, color: AppTheme.teal),
        title: const Text('Booking reminder'),
        content: Text(
          '${booking.fullName}\n'
          'Appointment: ${formatDateTime(booking.scheduledAt)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Dismiss'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              navContext.push('/bookings/${booking.id}');
            },
            child: const Text('View booking'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
