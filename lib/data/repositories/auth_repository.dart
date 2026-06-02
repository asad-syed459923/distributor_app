import '../providers/api_provider.dart';
import '../providers/hive_provider.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiProvider _apiProvider;
  final HiveProvider _hiveProvider;

  AuthRepository(this._apiProvider, this._hiveProvider);

  Future<UserModel> login(String email, String password) async {
    final response = await _apiProvider.login(email, password);
    if (response.statusCode == 200) {
      final user = UserModel.fromJson(response.data['user']);
      await _hiveProvider.saveUser(user);
      return user;
    } else {
      throw response.data['message'] ?? 'Login failed';
    }
  }

  UserModel? getCachedUser() => _hiveProvider.getUser();
  bool isLoggedIn() => _hiveProvider.isLoggedIn();
  Future<void> logout() => _hiveProvider.logout();
}
