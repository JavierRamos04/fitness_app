import 'package:drift/drift.dart';

import 'user_table.dart';
import 'workout_table.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  IntColumn get workoutId => integer().nullable().references(
    Workouts,
    #id,
    onDelete: KeyAction.setNull,
  )();

  DateTimeColumn get startedAt => dateTime()();

  DateTimeColumn get completedAt => dateTime().nullable()();

  IntColumn get durationSeconds => integer().nullable()();

  TextColumn get status => text()();
}