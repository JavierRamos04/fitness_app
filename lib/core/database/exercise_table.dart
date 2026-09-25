import 'package:drift/drift.dart';

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text()();

  TextColumn get primaryMuscle => text()();

  TextColumn get difficulty => text()();

  TextColumn get movementPattern => text()();

  TextColumn get exerciseType => text()();

  TextColumn get technique => text()();

  TextColumn get commonMistakes => text()();

  TextColumn get considerations => text()();

  TextColumn get instructions => text()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}