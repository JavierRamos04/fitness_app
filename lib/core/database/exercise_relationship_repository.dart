import 'app_database.dart';

class ExerciseRelationshipRepository {
  ExerciseRelationshipRepository(this._database);

  final AppDatabase _database;

  Future<void> save({
    required int exerciseId,
    required int relatedExerciseId,
    required String relationshipType,
  }) async {
    await _database.into(_database.exerciseRelationships).insert(
      ExerciseRelationshipsCompanion.insert(
        exerciseId: exerciseId,
        relatedExerciseId: relatedExerciseId,
        relationshipType: relationshipType,
      ),
    );
  }

  Future<List<ExerciseRelationship>> getForExercise(
      int exerciseId,
      ) {
    return (_database.select(_database.exerciseRelationships)
      ..where((table) => table.exerciseId.equals(exerciseId)))
        .get();
  }
}