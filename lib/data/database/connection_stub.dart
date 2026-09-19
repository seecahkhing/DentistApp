import 'package:drift/drift.dart';

Never _unsupported() =>
    throw UnsupportedError('No database backend for this platform.');

QueryExecutor createExecutor() => _unsupported();

QueryExecutor createMemoryExecutor() => _unsupported();
