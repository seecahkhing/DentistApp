import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../data/repositories/booking_repository.dart';
import '../../../../data/services/reminder_service.dart';
import '../../../../domain/models/booking.dart';

enum PeriodFilter { week, month, year }

enum BookingViewMode { calendar, kanban, list }

extension PeriodFilterX on PeriodFilter {
  String get label => switch (this) {
    PeriodFilter.week => 'Week',
    PeriodFilter.month => 'Month',
    PeriodFilter.year => 'Year',
  };
}

class BookingsViewModel extends ChangeNotifier {
  BookingsViewModel({
    required BookingRepository repository,
    required ReminderService reminderService,
  }) : _repository = repository,
       _reminderService = reminderService;

  final BookingRepository _repository;
  final ReminderService _reminderService;
  StreamSubscription<List<Booking>>? _subscription;

  PeriodFilter period = PeriodFilter.month;
  BookingViewMode viewMode = BookingViewMode.list;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  List<Booking> _all = [];
  bool loading = true;
  String? error;

  List<Booking> get all => List.unmodifiable(_all);

  DateTime get rangeStart {
    final day = DateTime(focusedDay.year, focusedDay.month, focusedDay.day);
    return switch (period) {
      PeriodFilter.week => day.subtract(Duration(days: day.weekday - 1)),
      PeriodFilter.month => DateTime(day.year, day.month),
      PeriodFilter.year => DateTime(day.year),
    };
  }

  DateTime get rangeEnd {
    return switch (period) {
      PeriodFilter.week => rangeStart.add(const Duration(days: 7)),
      PeriodFilter.month => DateTime(rangeStart.year, rangeStart.month + 1),
      PeriodFilter.year => DateTime(rangeStart.year + 1),
    };
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

  /// Reminders whose time has passed and appointment is still active.
  List<Booking> get dueReminders {
    final now = DateTime.now();
    final items = _all.where((b) {
      final at = b.reminderAt;
      if (at == null) return false;
      if (b.status == BookingStatus.cancelled ||
          b.status == BookingStatus.completed) {
        return false;
      }
      return !at.isAfter(now);
    }).toList();
    items.sort(
      (a, b) => (a.reminderAt ?? a.scheduledAt).compareTo(
        b.reminderAt ?? b.scheduledAt,
      ),
    );
    return items;
  }

  String get rangeLabel {
    final start = rangeStart;
    return switch (period) {
      PeriodFilter.week => () {
        final end = rangeEnd.subtract(const Duration(days: 1));
        return '${_short(start)} – ${_short(end)}';
      }(),
      PeriodFilter.month => '${_month(start)} ${start.year}',
      PeriodFilter.year => '${start.year}',
    };
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

  /// Keeps bookings in sync with the local database.
  void startWatching() {
    _subscription?.cancel();
    loading = true;
    error = null;
    notifyListeners();
    _subscription = _repository.watchAll().listen(
      (bookings) {
        _all = bookings;
        loading = false;
        error = null;
        notifyListeners();
      },
      onError: (Object e) {
        error = e.toString();
        loading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
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
    focusedDay = switch (period) {
      PeriodFilter.week => focusedDay.add(Duration(days: 7 * direction)),
      PeriodFilter.month => DateTime(focusedDay.year, focusedDay.month + direction),
      PeriodFilter.year => DateTime(focusedDay.year + direction, focusedDay.month, focusedDay.day),
    };
    selectedDay = focusedDay;
    notifyListeners();
  }

  Future<Booking> create(BookingDraft draft) async {
    final booking = await _repository.create(draft);
    await _syncReminder(booking);
    return booking;
  }

  Future<Booking> update(int id, BookingDraft draft) async {
    final booking = await _repository.update(id, draft);
    await _syncReminder(booking);
    return booking;
  }

  Future<void> setStatus(int id, BookingStatus status) async {
    await _repository.updateStatus(id, status);
  }

  Future<void> delete(int id) async {
    await _reminderService.cancel(id);
    await _repository.delete(id);
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
