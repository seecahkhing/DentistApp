import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

QueryExecutor createExecutor() {
  return driftDatabase(
    name: 'dental_booking',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}

QueryExecutor createMemoryExecutor() {
  return driftDatabase(
    name: 'dental_booking_memory',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
