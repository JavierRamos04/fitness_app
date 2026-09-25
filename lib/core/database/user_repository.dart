import 'app_database.dart';

class UserRepository {
  UserRepository(this._database);

  final AppDatabase _database;

  Future<User?> getUser() {
    return _database.select(_database.users).getSingleOrNull();
  }

  Future<void> saveUser(UsersCompanion user) async {
    await _database.into(_database.users).insert(user);
  }

  Future<void> updateUser(User user) async {
    await _database.update(_database.users).replace(user);
  }
}