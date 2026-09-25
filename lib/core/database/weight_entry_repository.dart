import 'package:drift/drift.dart';

import 'app_database.dart';

class WeightEntryRepository {
  WeightEntryRepository(this._database);

  final AppDatabase _database;

  Future<List<WeightEntry>> getAll() {
    return (_database.select(_database.weightEntries)
      ..orderBy([
            (table) => OrderingTerm.desc(table.recordedAt),
      ]))
        .get();
  }

  Future<void> save({
    required int userId,
    required DateTime recordedAt,
    required double weightKg,
  }) async {
    await _database.into(_database.weightEntries).insert(
      WeightEntriesCompanion.insert(
        userId: userId,
        recordedAt: recordedAt,
        weightKg: weightKg,
      ),
    );
  }
}