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

  /// Identifica el plan semanal al que pertenece la rutina. `null` si es una
  /// rutina suelta (creada a mano).
  TextColumn get planKey => text().nullable()();

  /// Orden de la rutina dentro de su plan (1, 2, 3…). `null` si no tiene plan.
  IntColumn get planPosition => integer().nullable()();
}