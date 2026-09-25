import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get birthDate => dateTime()();

  RealColumn get heightCm => real()();

  RealColumn get currentWeightKg => real()();

  TextColumn get fitnessLevel => text()();

  TextColumn get trainingLocation => text()();

  IntColumn get weeklyFrequency => integer()();

  IntColumn get availableMinutes => integer()();
}