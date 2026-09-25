import 'package:drift/drift.dart';

import 'app_database.dart';

class GoalRepository {
  GoalRepository(this._database);

  final AppDatabase _database;

  Future<List<Goal>> getAll() {
    return (_database.select(_database.goals)
      ..orderBy([
            (table) => OrderingTerm.desc(table.startDate),
      ]))
        .get();
  }

  Future<void> save({
    required int userId,
    required String type,
    required String name,
    required double targetValue,
    required String unit,
    required DateTime startDate,
    DateTime? targetDate,
    required String status,
  }) async {
    await _database.into(_database.goals).insert(
      GoalsCompanion.insert(
        userId: userId,
        type: type,
        name: name,
        targetValue: targetValue,
        unit: unit,
        startDate: startDate,
        targetDate: Value(targetDate),
        status: status,
      ),
    );
  }

  Future<void> updateGoal(Goal goal) async {
    await _database.update(_database.goals).replace(goal);
  }
}