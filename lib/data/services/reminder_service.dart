abstract class ReminderService {
  Future<void> init();

  Future<void> scheduleBookingReminder({
    required int id,
    required String patientName,
    required DateTime when,
    required DateTime appointmentAt,
  });

  Future<void> cancel(int id);
}

class NoopReminderService implements ReminderService {
  @override
  Future<void> init() async {}

  @override
  Future<void> scheduleBookingReminder({
    required int id,
    required String patientName,
    required DateTime when,
    required DateTime appointmentAt,
  }) async {}

  @override
  Future<void> cancel(int id) async {}
}
