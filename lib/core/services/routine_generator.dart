import 'dart:math' as math;

// Generador de rutinas sugeridas.
//
// Lógica pura: no depende de la base de datos ni de Flutter, así que se puede
// probar con tests. Construye una rutina de cuerpo completo según el nivel, el
// objetivo, el tiempo disponible y el equipo del usuario.

/// Datos mínimos de un ejercicio que necesita el generador.
class GeneratorExercise {
  const GeneratorExercise({
    required this.id,
    required this.name,
    required this.primaryMuscle,
    required this.movementPattern,
    required this.difficulty,
    required this.requiredEquipment,
  });

  final int id;
  final String name;
  final String primaryMuscle;
  final String movementPattern;
  final String difficulty;
  final Set<String> requiredEquipment;
}

/// Datos del usuario que condicionan la rutina.
class GeneratorProfile {
  const GeneratorProfile({
    required this.level,
    required this.goal,
    required this.minutes,
    required this.equipment,
  });

  /// `beginner`, `intermediate` o `advanced`.
  final String level;

  /// `strength`, `hypertrophy`, `fat_loss` o `general_fitness`.
  final String goal;

  /// Tiempo disponible por sesión, en minutos.
  final int minutes;

  /// Códigos del equipo disponible.
  final Set<String> equipment;
}

class SuggestedExercise {
  const SuggestedExercise({
    required this.exercise,
    required this.sets,
    required this.minReps,
    required this.maxReps,
    required this.restSeconds,
  });

  final GeneratorExercise exercise;
  final int sets;
  final int minReps;
  final int maxReps;
  final int restSeconds;
}

class SuggestedRoutine {
  const SuggestedRoutine({
    required this.exercises,
    required this.estimatedMinutes,
    this.equipmentTip,
  });

  final List<SuggestedExercise> exercises;
  final int estimatedMinutes;

  /// Sugerencia de equipo que mejoraría la rutina, si hay alguna.
  final String? equipmentTip;
}

enum _Slot {
  legs,
  pushHorizontal,
  pull,
  hinge,
  core,
  pushVertical,
  secondPull,
  biceps,
  triceps,
  calves,
  cardio,
}

class _Range {
  const _Range(this.minReps, this.maxReps, this.restSeconds);

  final int minReps;
  final int maxReps;
  final int restSeconds;
}

class _Prescription {
  const _Prescription({required this.main, required this.accessory});

  final _Range main;
  final _Range accessory;
}

class _Candidate {
  _Candidate(this.exercise, this.index);

  final GeneratorExercise exercise;

  /// Posición en el catálogo: desempata de forma estable.
  final int index;

  int score = 0;
}

class _Choice {
  const _Choice(this.slot, this.exercise);

  final _Slot slot;
  final GeneratorExercise exercise;
}

/// Repeticiones y descanso según el objetivo. Los ejercicios principales son
/// los compuestos (pierna, empuje, tirón y bisagra de cadera).
const Map<String, _Prescription> _prescriptions = {
  'strength': _Prescription(
    main: _Range(4, 6, 150),
    accessory: _Range(8, 10, 90),
  ),
  'hypertrophy': _Prescription(
    main: _Range(8, 12, 75),
    accessory: _Range(10, 15, 60),
  ),
  'fat_loss': _Prescription(
    main: _Range(12, 15, 45),
    accessory: _Range(12, 20, 45),
  ),
  'general_fitness': _Prescription(
    main: _Range(10, 12, 60),
    accessory: _Range(12, 15, 45),
  ),
};

/// Cuánta carga permite cada equipo. Se usa para preferir el ejercicio más
/// cargable cuando el objetivo es fuerza.
const Map<String, int> _equipmentLoad = {
  'barbell': 5,
  'pull_up_bar': 4,
  'gym_machine': 3,
  'cable_machine': 3,
  'dumbbells': 3,
  'resistance_band': 1,
  'bench': 0,
};

/// Ejercicios que se miden en tiempo o distancia. La app solo registra
/// repeticiones, así que de momento no se incluyen en las rutinas generadas.
const Set<String> _timeBasedExercises = {
  'Plancha',
  'Plancha lateral',
  'Farmer walk',
};

/// Equipo que se sugiere para desbloquear ejercicios de tirón, del más
/// económico al más caro.
const List<String> _pullTipEquipment = [
  'resistance_band',
  'dumbbells',
  'pull_up_bar',
];

const Map<String, String> _pullTipNames = {
  'resistance_band': 'una banda elástica',
  'dumbbells': 'mancuernas',
  'pull_up_bar': 'una barra de dominadas',
};

/// Patrones principales que reciben un ejercicio extra cuando sobra tiempo.
const List<_Slot> _extraVolumeSlots = [
  _Slot.legs,
  _Slot.pushHorizontal,
  _Slot.pull,
  _Slot.hinge,
];

const int _warmUpMinutes = 5;
const int _workSecondsPerSet = 40;
const int _transitionMinutes = 1;
const int _minExercises = 3;
const int _maxExercises = 9;

class RoutineGenerator {
  const RoutineGenerator();

  /// Genera una rutina de cuerpo completo.
  ///
  /// [variant] rota entre las mejores opciones de cada hueco: 0 devuelve la
  /// primera opción y valores mayores devuelven alternativas igual de
  /// adecuadas.
  SuggestedRoutine generate({
    required GeneratorProfile profile,
    required List<GeneratorExercise> catalog,
    int variant = 0,
  }) {
    final goal = _prescriptions.containsKey(profile.goal)
        ? profile.goal
        : 'general_fitness';
    final prescription = _prescriptions[goal]!;
    final levelRank = _difficultyRank(profile.level);
    final safeVariant = variant.abs();

    final pool = <_Candidate>[];

    for (var index = 0; index < catalog.length; index++) {
      final exercise = catalog[index];

      if (_isAllowed(exercise, profile, levelRank)) {
        pool.add(_Candidate(exercise, index));
      }
    }

    final sets = _setsFor(profile.level, goal, profile.minutes);

    final slots = <_Slot>[
      _Slot.legs,
      _Slot.pushHorizontal,
      _Slot.pull,
      _Slot.hinge,
      _Slot.core,
      _Slot.pushVertical,
      _Slot.secondPull,
      _Slot.biceps,
      _Slot.triceps,
      _Slot.calves,
    ];

    if (goal == 'fat_loss') {
      slots.insert(5, _Slot.cardio);
    }

    final chosen = <_Choice>[];
    final usedIds = <int>{};
    final unfilled = <_Slot>{};

    void addPick(_Slot slot, {required bool isExtra}) {
      final pick = _pickForSlot(
        slot: slot,
        pool: pool,
        chosen: chosen,
        usedIds: usedIds,
        unfilled: unfilled,
        goal: goal,
        levelRank: levelRank,
        variant: safeVariant,
        isExtra: isExtra,
      );

      if (pick != null) {
        chosen.add(_Choice(slot, pick));
        usedIds.add(pick.id);
      }
    }

    for (final slot in slots) {
      if (chosen.length >= _maxExercises) {
        break;
      }

      addPick(slot, isExtra: false);
    }

    // Segunda pasada: con tiempo de sobra y pocos ejercicios distintos, se
    // añade volumen en los patrones principales.
    for (final slot in _extraVolumeSlots) {
      if (chosen.length >= _maxExercises) {
        break;
      }

      addPick(slot, isExtra: true);
    }

    final exercises = <SuggestedExercise>[
      for (final choice in chosen)
        _prescribe(
          slot: choice.slot,
          exercise: choice.exercise,
          goal: goal,
          prescription: prescription,
          sets: sets,
        ),
    ];

    // Se llenan los huecos por prioridad y se recorta desde el final hasta
    // que la rutina quepa en el tiempo disponible.
    while (exercises.length > _minExercises &&
        _estimateMinutes(exercises) > profile.minutes) {
      exercises.removeLast();
    }

    return SuggestedRoutine(
      exercises: exercises,
      estimatedMinutes: _estimateMinutes(exercises),
      equipmentTip: unfilled.contains(_Slot.pull)
          ? _buildPullTip(profile, catalog, levelRank)
          : null,
    );
  }

  /// Elige el mejor ejercicio disponible para un hueco, o `null` si no hay.
  GeneratorExercise? _pickForSlot({
    required _Slot slot,
    required List<_Candidate> pool,
    required List<_Choice> chosen,
    required Set<int> usedIds,
    required Set<_Slot> unfilled,
    required String goal,
    required int levelRank,
    required int variant,
    required bool isExtra,
  }) {
    var candidates = pool
        .where(
          (candidate) =>
              _matches(slot, candidate.exercise) &&
              !usedIds.contains(candidate.exercise.id),
        )
        .toList();

    if (slot == _Slot.secondPull) {
      final firstPulls = chosen.where((choice) => choice.slot == _Slot.pull);

      if (firstPulls.isNotEmpty) {
        final firstPattern = firstPulls.first.exercise.movementPattern;

        final different = candidates
            .where(
              (candidate) => candidate.exercise.movementPattern != firstPattern,
            )
            .toList();

        if (different.isNotEmpty) {
          candidates = different;
        }
      }
    }

    if (candidates.isEmpty && slot == _Slot.pull && !isExtra) {
      // Respaldo: si no hay ningún tirón, al menos trabajar la espalda baja.
      candidates = pool
          .where(
            (candidate) =>
                candidate.exercise.movementPattern == 'back_extension' &&
                !usedIds.contains(candidate.exercise.id),
          )
          .toList();

      if (candidates.isNotEmpty) {
        unfilled.add(_Slot.pull);
      }
    }

    if (candidates.isEmpty) {
      if (!isExtra && (_isMain(slot) || slot == _Slot.pushVertical)) {
        unfilled.add(slot);
      }

      return null;
    }

    for (final candidate in candidates) {
      candidate.score = _score(candidate.exercise, slot, goal, levelRank);
    }

    candidates.sort((a, b) {
      final byScore = b.score.compareTo(a.score);

      return byScore != 0 ? byScore : a.index.compareTo(b.index);
    });

    // Solo se rota entre opciones casi igual de buenas que la mejor.
    final topScore = candidates.first.score;

    final tier = candidates
        .where((candidate) => candidate.score >= topScore - 1)
        .toList();

    return tier[variant % tier.length].exercise;
  }

  SuggestedExercise _prescribe({
    required _Slot slot,
    required GeneratorExercise exercise,
    required String goal,
    required _Prescription prescription,
    required int sets,
  }) {
    var range = _isMain(slot) ? prescription.main : prescription.accessory;

    // Sin carga externa no se puede trabajar con el rango de fuerza.
    if (goal == 'strength' && exercise.requiredEquipment.isEmpty) {
      range = prescription.accessory;
    }

    if (exercise.movementPattern == 'locomotion') {
      range = const _Range(12, 20, 45);
    }

    return SuggestedExercise(
      exercise: exercise,
      sets: sets,
      minReps: range.minReps,
      maxReps: range.maxReps,
      restSeconds: range.restSeconds,
    );
  }

  int _estimateMinutes(List<SuggestedExercise> exercises) {
    var total = _warmUpMinutes.toDouble();

    for (final item in exercises) {
      total +=
          item.sets * (_workSecondsPerSet + item.restSeconds) / 60 +
          _transitionMinutes;
    }

    return total.round();
  }

  int _setsFor(String level, String goal, int minutes) {
    if (level == 'beginner' && minutes <= 30) {
      return 2;
    }

    if (level != 'beginner' && goal == 'strength') {
      return 4;
    }

    return 3;
  }

  bool _isAllowed(
    GeneratorExercise exercise,
    GeneratorProfile profile,
    int levelRank,
  ) {
    if (_timeBasedExercises.contains(exercise.name)) {
      return false;
    }

    if (_difficultyRank(exercise.difficulty) > levelRank) {
      return false;
    }

    return profile.equipment.containsAll(exercise.requiredEquipment);
  }

  int _difficultyRank(String difficulty) {
    switch (difficulty) {
      case 'intermediate':
        return 1;
      case 'advanced':
        return 2;
      default:
        return 0;
    }
  }

  bool _isMain(_Slot slot) {
    return slot == _Slot.legs ||
        slot == _Slot.pushHorizontal ||
        slot == _Slot.pull ||
        slot == _Slot.hinge;
  }

  bool _matches(_Slot slot, GeneratorExercise exercise) {
    final pattern = exercise.movementPattern;
    final muscle = exercise.primaryMuscle;

    switch (slot) {
      case _Slot.legs:
        return pattern == 'squat' || pattern == 'lunge';
      case _Slot.pushHorizontal:
        return pattern == 'horizontal_push';
      case _Slot.pull:
        return (pattern == 'horizontal_pull' || pattern == 'vertical_pull') &&
            (muscle == 'upper_back' || muscle == 'latissimus');
      case _Slot.hinge:
        return pattern == 'hinge' || pattern == 'hip_extension';
      case _Slot.core:
        return pattern.startsWith('core_');
      case _Slot.pushVertical:
        return muscle == 'shoulders' &&
            (pattern == 'vertical_push' || pattern == 'shoulder_abduction');
      case _Slot.secondPull:
        return (pattern == 'horizontal_pull' || pattern == 'vertical_pull') &&
            (muscle == 'upper_back' ||
                muscle == 'latissimus' ||
                muscle == 'rear_delts');
      case _Slot.biceps:
        return muscle == 'biceps';
      case _Slot.triceps:
        return muscle == 'triceps';
      case _Slot.calves:
        return pattern == 'calf_raise';
      case _Slot.cardio:
        return pattern == 'locomotion';
    }
  }

  int _score(
    GeneratorExercise exercise,
    _Slot slot,
    String goal,
    int levelRank,
  ) {
    var score = 0;
    final needs = exercise.requiredEquipment;

    if (slot == _Slot.core) {
      // En el core se prefiere el ejercicio más simple.
      score -= needs.length;
    } else if (slot != _Slot.cardio) {
      if (goal == 'strength') {
        score += _maxLoad(needs) * 2;
      } else if (goal == 'hypertrophy' && needs.any((code) => code != 'bench')) {
        score += 2;
      }
    }

    if (_difficultyRank(exercise.difficulty) == levelRank) {
      score += 1;
    }

    return score;
  }

  int _maxLoad(Set<String> equipment) {
    var maxLoad = 0;

    for (final code in equipment) {
      maxLoad = math.max(maxLoad, _equipmentLoad[code] ?? 0);
    }

    return maxLoad;
  }

  String? _buildPullTip(
    GeneratorProfile profile,
    List<GeneratorExercise> catalog,
    int levelRank,
  ) {
    for (final code in _pullTipEquipment) {
      if (profile.equipment.contains(code)) {
        continue;
      }

      final extended = {...profile.equipment, code};

      final unlocksPull = catalog.any(
        (exercise) =>
            !_timeBasedExercises.contains(exercise.name) &&
            _matches(_Slot.pull, exercise) &&
            _difficultyRank(exercise.difficulty) <= levelRank &&
            extended.containsAll(exercise.requiredEquipment),
      );

      if (unlocksPull) {
        return 'Con ${_pullTipNames[code]} podrías añadir '
            'ejercicios de tirón (espalda).';
      }
    }

    return null;
  }
}
