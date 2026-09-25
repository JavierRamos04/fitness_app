import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase(
    driftDatabase(
      name: 'fitness_app',
    ),
  );

  ref.onDispose(database.close);

  return database;
});