import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'reminder_service.dart';

ReminderService createReminderServiceImpl() => LocalNotificationReminderService();

class LocalNotificationReminderService implements ReminderService {
  LocalNotificationReminderService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;

  @override
  Future<void> init() async {
    tzdata.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
    _ready = true;
  }

  @override
  Future<void> scheduleBookingReminder({
    required int id,
    required String patientName,
    required DateTime when,
    required DateTime appointmentAt,
  }) async {
    if (!_ready) await init();
    await cancel(id);
    if (!when.isAfter(DateTime.now())) return;

    final whenLocal = tz.TZDateTime.from(when, tz.local);
    final timeLabel = DateFormat.yMMMd().add_jm().format(appointmentAt);

    await _plugin.zonedSchedule(
      id,
      'Dental Booking reminder',
      '$patientName — $timeLabel',
      whenLocal,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'booking_reminders',
          'Booking reminders',
          channelDescription: 'Upcoming dental appointment reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel(int id) {
    return _plugin.cancel(id);
  }
}
