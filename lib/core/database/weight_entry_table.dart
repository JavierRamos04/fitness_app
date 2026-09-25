import 'package:drift/drift.dart';

class WeightEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer()();

  DateTimeColumn get recordedAt => dateTime()();

  RealColumn get weightKg => real()();
}