import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/providers/repository_providers.dart';

class WorkoutSessionState {
  const WorkoutSessionState({
    this.workoutId,
    this.sessionId,
    this.currentExerciseId,
    this.exercisePosition = 0,
    this.exerciseCount = 0,
    this.isActive = false,
    this.isLoading = false,
    this.errorMessage,
  });

  final int? workoutId;
  final int? sessionId;
  final int? currentExerciseId;
  final int exercisePosition;
  final int exerciseCount;
  final bool isActive;
  final bool isLoading;
  final String? errorMessage;

  WorkoutSessionState copyWith({
    int? workoutId,
    int? sessionId,
    int? currentExerciseId,
    int? exercisePosition,
    int? exerciseCount,
    bool? isActive,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WorkoutSessionState(
      workoutId: workoutId ?? this.workoutId,
      sessionId: sessionId ?? this.sessionId,
      currentExerciseId: currentExerciseId ?? this.currentExerciseId,
      exercisePosition: exercisePosition ?? this.exercisePosition,
      exerciseCount: exerciseCount ?? this.exerciseCount,
      isActive: isActive ?? this.isActive,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class WorkoutSessionController
    extends Notifier<WorkoutSessionState> {
  @override
  WorkoutSessionState build() {
    return const WorkoutSessionState();
  }

  Future<void> startSession({
    required int userId,
    int? workoutId,
    int exerciseCount = 0,
    int? firstExerciseId,
    required DateTime startedAt,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final sessionId =
      await ref.read(sessionRepositoryProvider).save(
        userId: userId,
        workoutId: workoutId,
        startedAt: startedAt,
      );

      int? sessionExerciseId;

      if (firstExerciseId != null) {
        sessionExerciseId =
        await ref.read(sessionExerciseRepositoryProvider).save(
          sessionId: sessionId,
          exerciseId: firstExerciseId,
          orderIndex: 1,
        );
      }

      state = WorkoutSessionState(
        workoutId: workoutId,
        sessionId: sessionId,
        currentExerciseId: sessionExerciseId,
        exercisePosition: firstExerciseId != null ? 1 : 0,
        exerciseCount: exerciseCount,
        isActive: true,
      );
    } catch (error) {
      state = WorkoutSessionState(
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> addExercise({
    required int exerciseId,
    required int orderIndex,
  }) async {
    final sessionId = state.sessionId;

    if (sessionId == null) {
      state = state.copyWith(
        errorMessage: 'No hay una sesión activa.',
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final sessionExerciseId =
      await ref.read(sessionExerciseRepositoryProvider).save(
        sessionId: sessionId,
        exerciseId: exerciseId,
        orderIndex: orderIndex,
      );

      state = state.copyWith(
        currentExerciseId: sessionExerciseId,
        exercisePosition: orderIndex,
        isLoading: false,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> addNextExercise({
    required int exerciseId,
    required int orderIndex,
  }) async {
    await addExercise(
      exerciseId: exerciseId,
      orderIndex: orderIndex,
    );
  }

  Future<void> addSet({
    required int setIndex,
    double? weightKg,
    required int repetitions,
    required String setType,
  }) async {
    final sessionExerciseId = state.currentExerciseId;

    if (sessionExerciseId == null) {
      state = state.copyWith(
        errorMessage: 'No hay un ejercicio activo.',
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      await ref.read(setRepositoryProvider).save(
        sessionExerciseId: sessionExerciseId,
        setIndex: setIndex,
        weightKg: weightKg,
        repetitions: repetitions,
        setType: setType,
      );

      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> completeSession({
    required DateTime completedAt,
    required int durationSeconds,
  }) async {
    final sessionId = state.sessionId;

    if (sessionId == null) {
      state = state.copyWith(
        errorMessage: 'No hay una sesión activa.',
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      await ref.read(sessionRepositoryProvider).complete(
        sessionId: sessionId,
        completedAt: completedAt,
        durationSeconds: durationSeconds,
      );

      state = const WorkoutSessionState();
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> cancelSession() async {
    final sessionId = state.sessionId;

    if (sessionId == null) {
      state = state.copyWith(
        errorMessage: 'No hay una sesión activa.',
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      await ref.read(sessionRepositoryProvider).cancel(sessionId);

      state = const WorkoutSessionState();
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      );
    }
  }
}

final workoutSessionControllerProvider =
NotifierProvider<WorkoutSessionController, WorkoutSessionState>(
  WorkoutSessionController.new,
);