import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/distributor_model.dart';
import '../models/route_model.dart';
import '../models/attendance_model.dart';

class HiveProvider {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(DistributorModelAdapter());
    Hive.registerAdapter(RouteModelAdapter());
    Hive.registerAdapter(AttendanceModelAdapter());

    await Hive.openBox<UserModel>(AppConstants.profileBox);
    await Hive.openBox<AttendanceModel>(AppConstants.attendanceBox);
    await Hive.openBox(AppConstants.authBox);
  }

  Box<UserModel> get profileBox => Hive.box<UserModel>(AppConstants.profileBox);
  Box<AttendanceModel> get attendanceBox => Hive.box<AttendanceModel>(AppConstants.attendanceBox);
  Box get authBox => Hive.box(AppConstants.authBox);

  Future<void> saveUser(UserModel user) async {
    await profileBox.put(AppConstants.keyUser, user);
    await authBox.put(AppConstants.keyIsLoggedIn, true);
  }

  Future<void> saveToken(String token) async {
    await authBox.put(AppConstants.keyToken, token);
  }

  String? getToken() => authBox.get(AppConstants.keyToken);

  UserModel? getUser() => profileBox.get(AppConstants.keyUser);

  bool isLoggedIn() => authBox.get(AppConstants.keyIsLoggedIn, defaultValue: false);

  Future<void> logout() async {
    await authBox.put(AppConstants.keyIsLoggedIn, false);
    await authBox.delete(AppConstants.keyToken);
    await authBox.delete(AppConstants.keyActiveAttendanceId);
    await authBox.delete(AppConstants.keyIsCheckedIn);
    await authBox.delete(AppConstants.keyCheckInTime);
    await profileBox.clear();
  }

  Future<void> saveCheckInState({
    required bool checkedIn,
    int? attendanceId,
    String? time,
  }) async {
    await authBox.put(AppConstants.keyIsCheckedIn, checkedIn);
    if (attendanceId != null) {
      await authBox.put(AppConstants.keyActiveAttendanceId, attendanceId);
    }
    if (time != null) {
      await authBox.put(AppConstants.keyCheckInTime, time);
    }
  }

  bool isCheckedIn() => authBox.get(AppConstants.keyIsCheckedIn, defaultValue: false);

  int? activeAttendanceId() => authBox.get(AppConstants.keyActiveAttendanceId);

  String? checkInTime() => authBox.get(AppConstants.keyCheckInTime);

  Future<void> clearCheckInState() async {
    await authBox.delete(AppConstants.keyActiveAttendanceId);
    await authBox.put(AppConstants.keyIsCheckedIn, false);
    await authBox.delete(AppConstants.keyCheckInTime);
  }

  Future<void> addAttendance(AttendanceModel attendance) async {
    await attendanceBox.add(attendance);
  }

  List<AttendanceModel> getAttendanceHistory() {
    return attendanceBox.values.toList().reversed.toList();
  }

  Future<void> markAsSynced(dynamic key, {int? serverId}) async {
    final record = attendanceBox.get(key);
    if (record == null) return;

    await attendanceBox.put(
      key,
      AttendanceModel(
        dateTime: record.dateTime,
        userId: record.userId,
        latitude: record.latitude,
        longitude: record.longitude,
        distributorId: record.distributorId,
        routeId: record.routeId,
        type: record.type,
        isSynced: true,
        serverId: serverId ?? record.serverId,
      ),
    );
  }
}
