import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String? phone;
  @HiveField(4)
  final String? designation;
  @HiveField(5)
  final String? department;
  @HiveField(6)
  final String? joiningDate;
  @HiveField(7)
  final String? profileImage;
  @HiveField(8)
  final String? employeeId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.designation,
    this.department,
    this.joiningDate,
    this.profileImage,
    this.employeeId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      designation: json['designation'],
      department: json['department'],
      joiningDate: json['joining_date'],
      profileImage: json['profile_image'],
      employeeId: json['employee_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'designation': designation,
      'department': department,
      'joining_date': joiningDate,
      'profile_image': profileImage,
      'employee_id': employeeId,
    };
  }
}
