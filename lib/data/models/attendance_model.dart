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
  final String type;
  @HiveField(7)
  final bool isSynced;
  @HiveField(8)
  final int? serverId;

  AttendanceModel({
    required this.dateTime,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.distributorId,
    required this.routeId,
    required this.type,
    this.isSynced = false,
    this.serverId,
  });

  Map<String, dynamic> toApiPayload({int? checkoutId}) {
    final map = <String, dynamic>{
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'distributor_id': distributorId,
      'route_id': routeId,
    };

    if (type == 'in') {
      map['in'] = dateTime;
    } else {
      map['out'] = dateTime;
      final id = serverId ?? checkoutId;
      if (id != null) map['id'] = id;
    }

    return map;
  }
}
