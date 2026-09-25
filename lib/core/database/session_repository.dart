import 'package:drift/drift.dart';

import 'app_database.dart';

class SessionRepository {
  SessionRepository(this._database);

  final AppDatabase _database;

  Future<List<Session>> getAll() {
    return (_database.select(_database.sessions)
      ..orderBy([
            (table) => OrderingTerm.desc(table.startedAt),
      ]))
        .get();
  }

  Future<int> save({
    required int userId,
    int? workoutId,
    required DateTime startedAt,
  }) {
    return _database.into(_database.sessions).insert(
      SessionsCompanion.insert(
        userId: userId,
        workoutId: Value(workoutId),
        startedAt: startedAt,
        status: 'in_progress',
      ),
    );
  }

  Future<void> update(Session session) async {
    await _database.update(_database.sessions).replace(session);
  }

  Future<void> complete({
    required int sessionId,
    required DateTime completedAt,
    required int durationSeconds,
  }) async {
    await (_database.update(_database.sessions)
      ..where((table) => table.id.equals(sessionId)))
        .write(
      SessionsCompanion(
        completedAt: Value(completedAt),
        durationSeconds: Value(durationSeconds),
        status: const Value('completed'),
      ),
    );
  }

  Future<void> cancel(int sessionId) async {
    await (_database.update(_database.sessions)
      ..where((table) => table.id.equals(sessionId)))
        .write(
      const SessionsCompanion(
        status: Value('cancelled'),
      ),
    );
  }
}