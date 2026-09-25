import 'package:drift/drift.dart';

import 'user_table.dart';

class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text()();

  TextColumn get goal => text()();

  TextColumn get difficulty => text()();

  IntColumn get daysPerWeek => integer()();

  IntColumn get estimatedDurationMinutes => integer()();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
}