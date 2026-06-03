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
    return _parseList(response, DistributorModel.fromJson, 'Could not load distributors');
  }

  Future<List<RouteModel>> getRoutes(int distributorId) async {
    final response = await _apiProvider.getRoutes(distributorId);
    return _parseList(response, RouteModel.fromJson, 'Could not load routes');
  }

  Future<void> saveAttendance(AttendanceModel attendance) async {
    await _hiveProvider.addAttendance(attendance);
    await _hiveProvider.saveCheckInState(
      checkedIn: attendance.type == 'in',
      time: attendance.dateTime,
    );
  }

  List<AttendanceModel> getAttendanceHistory() => _hiveProvider.getAttendanceHistory();

  bool isCheckedIn() => _hiveProvider.isCheckedIn();

  String? checkInTime() => _hiveProvider.checkInTime();

  Future<void> syncAttendance(dynamic key) async {
    final attendance = _hiveProvider.attendanceBox.get(key);
    if (attendance == null || attendance.isSynced) return;

    final payload = attendance.toApiPayload(
      checkoutId: _hiveProvider.activeAttendanceId(),
    );
    final response = attendance.type == 'in'
        ? await _apiProvider.checkIn(payload)
        : await _apiProvider.checkOut(payload);

    final body = response.data as Map<String, dynamic>;
    if (response.statusCode != 200 || body['success'] != true) {
      throw body['message'] ?? 'Sync failed';
    }

    final serverId = _readId(body['data']);

    if (attendance.type == 'in' && serverId != null) {
      await _hiveProvider.saveCheckInState(
        checkedIn: true,
        attendanceId: serverId,
        time: attendance.dateTime,
      );
    } else if (attendance.type == 'out') {
      await _hiveProvider.clearCheckInState();
    }

    await _hiveProvider.markAsSynced(key, serverId: serverId);
  }

  List<T> _parseList<T>(
    dynamic response,
    T Function(Map<String, dynamic>) fromJson,
    String fallbackError,
  ) {
    final body = response.data as Map<String, dynamic>;
    if (response.statusCode == 200 && body['success'] == true) {
      final list = body['data'] as List? ?? [];
      return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    }
    throw body['message'] ?? fallbackError;
  }

  int? _readId(dynamic data) {
    if (data is List && data.isNotEmpty) return data.first['id'] as int?;
    if (data is Map) return data['id'] as int?;
    return null;
  }
}
