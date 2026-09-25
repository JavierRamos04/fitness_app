import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database_provider.dart';
import '../goal_repository.dart';
import '../user_repository.dart';
import '../weight_entry_repository.dart';
import '../exercise_equipment_repository.dart';
import '../exercise_relationship_repository.dart';
import '../workout_exercise_repository.dart';
import '../session_exercise_repository.dart';
import '../set_repository.dart';
import '../session_repository.dart';
import '../workout_repository.dart';
import '../history_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return UserRepository(database);
});

final weightEntryRepositoryProvider = Provider<WeightEntryRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return WeightEntryRepository(database);
});

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return GoalRepository(database);
});

final exerciseEquipmentRepositoryProvider =
Provider<ExerciseEquipmentRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return ExerciseEquipmentRepository(database);
});

final exerciseRelationshipRepositoryProvider =
Provider<ExerciseRelationshipRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return ExerciseRelationshipRepository(database);
});

final workoutExerciseRepositoryProvider =
Provider<WorkoutExerciseRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return WorkoutExerciseRepository(database);
});

final sessionExerciseRepositoryProvider =
Provider<SessionExerciseRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return SessionExerciseRepository(database);
});

final setRepositoryProvider = Provider<SetRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return SetRepository(database);
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return SessionRepository(database);
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return WorkoutRepository(database);
});


final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(
    ref.read(databaseProvider),
  );
});