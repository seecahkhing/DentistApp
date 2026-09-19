import 'reminder_service.dart';

/// Local OS notifications were removed to avoid iOS SPM bundle build failures.
/// Reminders are stored on the booking and surfaced in-app on the home screen.
ReminderService createReminderService() => NoopReminderService();
