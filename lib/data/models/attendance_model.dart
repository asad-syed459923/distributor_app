import 'package:hive/hive.dart';

part 'attendance_model.g.dart';

@HiveType(typeId: 3)
class AttendanceModel extends HiveObject {
  @HiveField(0)
  final String dateTime;
  @HiveField(1)
  final int userId;
  @HiveField(2)
  final double latitude;
  @HiveField(3)
  final double longitude;
  @HiveField(4)
  final int distributorId;
  @HiveField(5)
  final int routeId;
  @HiveField(6)
  final String type; // 'in' or 'out'
  @HiveField(7)
  final bool isSynced;

  AttendanceModel({
    required this.dateTime,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.distributorId,
    required this.routeId,
    required this.type,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'in': type == 'in' ? dateTime : null,
      'out': type == 'out' ? dateTime : null,
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'distributor_id': distributorId,
      'route_id': routeId,
    }..removeWhere((key, value) => value == null);
  }
}
