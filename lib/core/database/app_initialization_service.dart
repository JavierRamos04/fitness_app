import 'app_database.dart';
import 'exercise_seed.dart';
import 'user_repository.dart';

class AppInitializationService {
  AppInitializationService(this._database);

  final AppDatabase _database;

  Future<bool> initialize() async {
    await _seedExercises();

    final userRepository = UserRepository(_database);
    final user = await userRepository.getUser();

    return user != null;
  }

  Future<void> _seedExercises() async {
    final existingExercises = await _database.select(_database.exercises).get();

    final existingNames = existingExercises
        .map((exercise) => exercise.name.trim().toLowerCase())
        .toSet();

    final exercisesToInsert = initialExercises.where((exercise) {
      final name = exercise.name.value.trim().toLowerCase();

      return !existingNames.contains(name);
    }).toList();

    if (exercisesToInsert.isEmpty) {
      return;
    }

    await _database.batch((batch) {
      batch.insertAll(_database.exercises, exercisesToInsert);
    });
  }
}
