import '../providers/api_provider.dart';
import '../providers/hive_provider.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiProvider _apiProvider;
  final HiveProvider _hiveProvider;

  AuthRepository(this._apiProvider, this._hiveProvider);

  Future<UserModel> login(String email, String password) async {
    final response = await _apiProvider.login(email, password);
    final body = response.data as Map<String, dynamic>;

    if (response.statusCode != 200 || body['success'] != true) {
      throw body['message'] ?? 'Login failed';
    }

    final data = body['data'] as Map<String, dynamic>;
    final user = UserModel.fromJson(data);

    await _hiveProvider.saveUser(user);

    final token = data['token'];
    if (token != null) {
      await _hiveProvider.saveToken(token.toString());
    }

    final attendence = data['attendence'] as Map<String, dynamic>?;
    if (attendence != null && attendence['out'] == null) {
      await _hiveProvider.saveCheckInState(
        checkedIn: true,
        attendanceId: attendence['id'] as int?,
        time: attendence['in']?.toString(),
      );
    } else {
      await _hiveProvider.clearCheckInState();
    }

    return user;
  }

  UserModel? getUser() => _hiveProvider.getUser();
  bool isLoggedIn() => _hiveProvider.isLoggedIn();
  Future<void> logout() => _hiveProvider.logout();
}
