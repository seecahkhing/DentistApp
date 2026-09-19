import 'reminder_service.dart';
import 'reminder_service_stub.dart'
    if (dart.library.io) 'reminder_service_io.dart';

ReminderService createReminderService() => createReminderServiceImpl();
