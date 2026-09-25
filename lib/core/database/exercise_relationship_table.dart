import 'package:drift/drift.dart';

import 'exercise_table.dart';

class ExerciseRelationships extends Table {
  IntColumn get id => integer().autoIncrement()();

  @ReferenceName('sourceExercise')
  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.cascade)();

  @ReferenceName('relatedExercise')
  IntColumn get relatedExerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.cascade)();

  TextColumn get relationshipType => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {exerciseId, relatedExerciseId, relationshipType},
  ];
}