import 'package:hive/hive.dart';

part 'distributor_model.g.dart';

@HiveType(typeId: 1)
class DistributorModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  DistributorModel({required this.id, required this.name});

  factory DistributorModel.fromJson(Map<String, dynamic> json) {
    return DistributorModel(
      id: json['id'] ?? 0,
      name: json['distributor_name'] ?? json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
