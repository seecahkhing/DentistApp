import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';

QueryExecutor createExecutor() {
  return driftDatabase(name: 'dental_booking');
}

QueryExecutor createMemoryExecutor() {
  return NativeDatabase.memory();
}
