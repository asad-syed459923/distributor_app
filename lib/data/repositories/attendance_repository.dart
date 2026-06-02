import '../providers/api_provider.dart';
import '../providers/hive_provider.dart';
import '../models/distributor_model.dart';
import '../models/route_model.dart';
import '../models/attendance_model.dart';

class AttendanceRepository {
  final ApiProvider _apiProvider;
  final HiveProvider _hiveProvider;

  AttendanceRepository(this._apiProvider, this._hiveProvider);

  Future<List<DistributorModel>> getDistributors() async {
    final response = await _apiProvider.getDistributors();
    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => DistributorModel.fromJson(e)).toList();
    } else {
      throw 'Failed to fetch distributors';
    }
  }

  Future<List<RouteModel>> getRoutes(int distributorId) async {
    final response = await _apiProvider.getRoutes(distributorId);
    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => RouteModel.fromJson(e)).toList();
    } else {
      throw 'Failed to fetch routes';
    }
  }

  Future<void> saveAttendanceLocally(AttendanceModel attendance) async {
    await _hiveProvider.addAttendance(attendance);
  }

  List<AttendanceModel> getAttendanceHistory() => _hiveProvider.getAttendanceHistory();

  Future<void> syncAttendance(int index) async {
    final attendance = _hiveProvider.attendanceBox.getAt(index);
    if (attendance == null || attendance.isSynced) return;

    final data = attendance.toJson();
    final response = attendance.type == 'in' 
        ? await _apiProvider.checkIn(data)
        : await _apiProvider.checkOut(data);

    if (response.statusCode == 200) {
      await _hiveProvider.markAsSynced(index);
    } else {
      throw 'Failed to sync attendance';
    }
  }
}
