import 'package:dental_booking/data/database/app_database.dart';
import 'package:dental_booking/data/repositories/booking_repository.dart';
import 'package:dental_booking/data/services/reminder_service.dart';
import 'package:dental_booking/domain/models/booking.dart';
import 'package:dental_booking/ui/features/bookings/view_models/bookings_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late BookingsViewModel vm;

  setUp(() {
    db = AppDatabase.memory();
    vm = BookingsViewModel(
      repository: BookingRepository(db),
      reminderService: NoopReminderService(),
    );
  });

  tearDown(() async {
    vm.dispose();
    await db.close();
  });

  BookingDraft draft({
    String name = 'Jane Doe',
    DateTime? when,
    DateTime? reminderAt,
    BookingStatus status = BookingStatus.scheduled,
  }) {
    return BookingDraft(
      fullName: name,
      address: '1 Clinic St',
      mobileNumber: '09171234567',
      hasInsurance: true,
      insuranceName: 'PhilHealth',
      scheduledAt: when ?? DateTime.now().add(const Duration(days: 1)),
      price: 1500,
      status: status,
      reminderAt: reminderAt,
    );
  }

  test('create, update, delete booking', () async {
    await vm.load();
    expect(vm.all, isEmpty);

    final created = await vm.create(draft());
    await vm.load();
    expect(vm.all, hasLength(1));
    expect(created.fullName, 'Jane Doe');

    await vm.update(created.id, draft(name: 'Jane D.'));
    await vm.load();
    expect(vm.byId(created.id)?.fullName, 'Jane D.');

    await vm.delete(created.id);
    await vm.load();
    expect(vm.all, isEmpty);
  });

  test('dueReminders includes past reminder times only', () async {
    await vm.create(
      draft(
        name: 'Due',
        reminderAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    );
    await vm.create(
      draft(
        name: 'Future',
        reminderAt: DateTime.now().add(const Duration(hours: 2)),
      ),
    );
    await vm.load();

    expect(vm.dueReminders.map((b) => b.fullName), ['Due']);
  });

  test('week filter excludes next month', () async {
    final now = DateTime.now();
    await vm.create(draft(name: 'This week', when: now));
    await vm.create(
      draft(
        name: 'Next month',
        when: DateTime(now.year, now.month + 1, 15),
      ),
    );
    await vm.load();
    vm.setPeriod(PeriodFilter.week);
    vm.setFocusedDay(now);
    expect(vm.bookingsInRange.map((b) => b.fullName), contains('This week'));
    expect(
      vm.bookingsInRange.map((b) => b.fullName),
      isNot(contains('Next month')),
    );
  });
}
