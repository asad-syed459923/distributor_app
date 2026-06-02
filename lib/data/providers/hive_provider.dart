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

  UserModel? getUser() {
    return profileBox.get(AppConstants.keyUser);
  }

  bool isLoggedIn() {
    return authBox.get(AppConstants.keyIsLoggedIn, defaultValue: false);
  }

  Future<void> logout() async {
    await authBox.put(AppConstants.keyIsLoggedIn, false);
    await profileBox.clear();
  }

  Future<void> addAttendance(AttendanceModel attendance) async {
    await attendanceBox.add(attendance);
  }

  List<AttendanceModel> getAttendanceHistory() {
    return attendanceBox.values.toList().reversed.toList();
  }

  Future<void> markAsSynced(int index) async {
    final attendance = attendanceBox.getAt(index);
    if (attendance != null) {
      final updated = AttendanceModel(
        dateTime: attendance.dateTime,
        userId: attendance.userId,
        latitude: attendance.latitude,
        longitude: attendance.longitude,
        distributorId: attendance.distributorId,
        routeId: attendance.routeId,
        type: attendance.type,
        isSynced: true,
      );
      await attendanceBox.putAt(index, updated);
    }
  }
}
