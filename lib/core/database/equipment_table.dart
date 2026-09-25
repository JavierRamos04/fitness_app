import 'package:drift/drift.dart';

class Equipment extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get code => text().unique()();

  TextColumn get name => text()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}