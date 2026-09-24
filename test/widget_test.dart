import 'package:dental_booking/data/database/app_database.dart';
import 'package:dental_booking/data/repositories/booking_repository.dart';
import 'package:dental_booking/data/services/reminder_service.dart';
import 'package:dental_booking/main.dart';
import 'package:dental_booking/ui/features/bookings/view_models/bookings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home shows Dental Booking', (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final vm = BookingsViewModel(
      repository: BookingRepository(db),
      reminderService: NoopReminderService(),
    );
    await vm.load();

    await tester.pumpWidget(DentalBookingApp(viewModel: vm));
    await tester.pumpAndSettle();

    expect(find.text('Bookings'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
  });
}
