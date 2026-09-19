import 'package:drift/drift.dart';

import '../../domain/models/booking.dart';
import 'connection.dart';

part 'app_database.g.dart';

@DataClassName('BookingRow')
class Bookings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fullName => text()();
  TextColumn get address => text()();
  TextColumn get mobileNumber => text()();
  BoolColumn get hasInsurance => boolean().withDefault(const Constant(false))();
  TextColumn get insuranceName => text().nullable()();
  DateTimeColumn get scheduledAt => dateTime()();
  RealColumn get price => real().nullable()();
  TextColumn get status => textEnum<BookingStatus>()();
  DateTimeColumn get reminderAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DriftDatabase(tables: [Bookings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  factory AppDatabase.memory() => AppDatabase(openMemoryConnection());

  @override
  int get schemaVersion => 1;
}
