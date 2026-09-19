import 'package:drift/drift.dart';

import '../../domain/models/booking.dart';
import '../database/app_database.dart';

class BookingRepository {
  BookingRepository(this._db);

  final AppDatabase _db;

  Booking _toDomain(BookingRow row) {
    return Booking(
      id: row.id,
      fullName: row.fullName,
      address: row.address,
      mobileNumber: row.mobileNumber,
      hasInsurance: row.hasInsurance,
      insuranceName: row.insuranceName,
      scheduledAt: row.scheduledAt,
      price: row.price,
      status: row.status,
      reminderAt: row.reminderAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<List<Booking>> watchRange(DateTime start, DateTime end) {
    return (_db.select(_db.bookings)
          ..where((t) => t.scheduledAt.isBiggerOrEqualValue(start))
          ..where((t) => t.scheduledAt.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .get()
        .then((rows) => rows.map(_toDomain).toList());
  }

  Stream<List<Booking>> watchAll() {
    final query = _db.select(_db.bookings)
      ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  Future<List<Booking>> getAll() async {
    final rows = await (_db.select(_db.bookings)
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .get();
    return rows.map(_toDomain).toList();
  }

  Future<Booking?> getById(int id) async {
    final query = _db.select(_db.bookings)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<Booking> create(BookingDraft draft) async {
    final now = DateTime.now();
    final id = await _db
        .into(_db.bookings)
        .insert(
          BookingsCompanion.insert(
            fullName: draft.fullName,
            address: draft.address,
            mobileNumber: draft.mobileNumber,
            hasInsurance: Value(draft.hasInsurance),
            insuranceName: Value(draft.insuranceName),
            scheduledAt: draft.scheduledAt,
            price: Value(draft.price),
            status: draft.status,
            reminderAt: Value(draft.reminderAt),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (await getById(id))!;
  }

  Future<Booking> update(int id, BookingDraft draft) async {
    final now = DateTime.now();
    await (_db.update(_db.bookings)..where((t) => t.id.equals(id))).write(
      BookingsCompanion(
        fullName: Value(draft.fullName),
        address: Value(draft.address),
        mobileNumber: Value(draft.mobileNumber),
        hasInsurance: Value(draft.hasInsurance),
        insuranceName: Value(draft.insuranceName),
        scheduledAt: Value(draft.scheduledAt),
        price: Value(draft.price),
        status: Value(draft.status),
        reminderAt: Value(draft.reminderAt),
        updatedAt: Value(now),
      ),
    );
    return (await getById(id))!;
  }

  Future<void> updateStatus(int id, BookingStatus status) async {
    await (_db.update(_db.bookings)..where((t) => t.id.equals(id))).write(
      BookingsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> delete(int id) {
    return (_db.delete(_db.bookings)..where((t) => t.id.equals(id))).go();
  }
}
