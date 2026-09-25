import 'package:drift/drift.dart';

class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer()();

  TextColumn get type => text()();

  TextColumn get name => text()();

  RealColumn get targetValue => real()();

  TextColumn get unit => text()();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get targetDate => dateTime().nullable()();

  TextColumn get status => text()();
}