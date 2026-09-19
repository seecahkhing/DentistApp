import 'package:flutter/foundation.dart';

import '../../../data/repositories/booking_repository.dart';
import '../../../data/services/reminder_service.dart';
import '../../../domain/models/booking.dart';

enum PeriodFilter { week, month }

enum BookingViewMode { calendar, kanban, list }

class BookingsViewModel extends ChangeNotifier {
  BookingsViewModel({
    required BookingRepository repository,
    required ReminderService reminderService,
  }) : _repository = repository,
       _reminderService = reminderService;

  final BookingRepository _repository;
  final ReminderService _reminderService;

  PeriodFilter period = PeriodFilter.week;
  BookingViewMode viewMode = BookingViewMode.list;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  List<Booking> _all = [];
  bool loading = true;
  String? error;

  List<Booking> get all => List.unmodifiable(_all);

  DateTime get rangeStart {
    final day = DateTime(focusedDay.year, focusedDay.month, focusedDay.day);
    if (period == PeriodFilter.week) {
      return day.subtract(Duration(days: day.weekday - 1));
    }
    return DateTime(day.year, day.month);
  }

  DateTime get rangeEnd {
    if (period == PeriodFilter.week) {
      return rangeStart.add(const Duration(days: 7));
    }
    return DateTime(rangeStart.year, rangeStart.month + 1);
  }

  List<Booking> get bookingsInRange {
    return _all
        .where(
          (b) =>
              !b.scheduledAt.isBefore(rangeStart) &&
              b.scheduledAt.isBefore(rangeEnd),
        )
        .toList();
  }

  List<Booking> bookingsOn(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return _all
        .where(
          (b) => !b.scheduledAt.isBefore(start) && b.scheduledAt.isBefore(end),
        )
        .toList();
  }

  List<Booking> byStatus(BookingStatus status) {
    return bookingsInRange.where((b) => b.status == status).toList();
  }

  List<Booking> get upcomingReminders {
    final now = DateTime.now();
    final soon = now.add(const Duration(days: 7));
    final items = _all
        .where((b) {
          final at = b.reminderAt;
          if (at == null) return false;
          if (b.status == BookingStatus.cancelled ||
              b.status == BookingStatus.completed) {
            return false;
          }
          return !at.isAfter(soon);
        })
        .toList();
    items.sort(
      (a, b) => (a.reminderAt ?? a.scheduledAt).compareTo(
        b.reminderAt ?? b.scheduledAt,
      ),
    );
    return items;
  }

  String get rangeLabel {
    final start = rangeStart;
    if (period == PeriodFilter.week) {
      final end = rangeEnd.subtract(const Duration(days: 1));
      return '${_short(start)} – ${_short(end)}';
    }
    return '${_month(start)} ${start.year}';
  }

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      _all = await _repository.getAll();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void setPeriod(PeriodFilter value) {
    period = value;
    notifyListeners();
  }

  void setViewMode(BookingViewMode value) {
    viewMode = value;
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    focusedDay = day;
    selectedDay = day;
    notifyListeners();
  }

  void shiftRange(int direction) {
    if (period == PeriodFilter.week) {
      focusedDay = focusedDay.add(Duration(days: 7 * direction));
    } else {
      focusedDay = DateTime(focusedDay.year, focusedDay.month + direction);
    }
    selectedDay = focusedDay;
    notifyListeners();
  }

  Future<Booking> create(BookingDraft draft) async {
    final booking = await _repository.create(draft);
    await _syncReminder(booking);
    await load();
    return booking;
  }

  Future<Booking> update(int id, BookingDraft draft) async {
    final booking = await _repository.update(id, draft);
    await _syncReminder(booking);
    await load();
    return booking;
  }

  Future<void> setStatus(int id, BookingStatus status) async {
    await _repository.updateStatus(id, status);
    await load();
  }

  Future<void> delete(int id) async {
    await _reminderService.cancel(id);
    await _repository.delete(id);
    await load();
  }

  Booking? byId(int id) {
    for (final booking in _all) {
      if (booking.id == id) return booking;
    }
    return null;
  }

  Future<void> _syncReminder(Booking booking) async {
    if (booking.reminderAt == null) {
      await _reminderService.cancel(booking.id);
      return;
    }
    await _reminderService.scheduleBookingReminder(
      id: booking.id,
      patientName: booking.fullName,
      when: booking.reminderAt!,
      appointmentAt: booking.scheduledAt,
    );
  }

  String _short(DateTime d) => '${d.day} ${_month(d)}';

  String _month(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[d.month - 1];
  }
}
