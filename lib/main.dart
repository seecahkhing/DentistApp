import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/database/app_database.dart';
import 'data/repositories/booking_repository.dart';
import 'data/services/reminder_service_factory.dart';
import 'routing/app_router.dart';
import 'ui/core/app_theme.dart';
import 'ui/core/widgets/in_app_reminder_listener.dart';
import 'ui/features/bookings/view_models/bookings_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final reminders = createReminderService();
  await reminders.init();
  final viewModel = BookingsViewModel(
    repository: BookingRepository(AppDatabase()),
    reminderService: reminders,
  );
  viewModel.startWatching();
  runApp(DentalBookingApp(viewModel: viewModel));
}

class DentalBookingApp extends StatefulWidget {
  const DentalBookingApp({super.key, required this.viewModel});

  final BookingsViewModel viewModel;

  @override
  State<DentalBookingApp> createState() => _DentalBookingAppState();
}

class _DentalBookingAppState extends State<DentalBookingApp> {
  late final _router = createRouter();

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookingsViewModel>.value(
      value: widget.viewModel,
      child: InAppReminderListener(
        child: MaterialApp.router(
          title: 'Aerea',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          routerConfig: _router,
        ),
      ),
    );
  }
}
