import 'package:get/get.dart';
import '../../data/providers/api_provider.dart';
import '../../data/providers/hive_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../core/utils/location_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HiveProvider(), permanent: true);
    Get.put(ApiProvider(Get.find<HiveProvider>()), permanent: true);
    Get.put(LocationService(), permanent: true);
    
    Get.put(AuthRepository(Get.find<ApiProvider>(), Get.find<HiveProvider>()), permanent: true);
    Get.put(AttendanceRepository(Get.find<ApiProvider>(), Get.find<HiveProvider>()), permanent: true);
  }
}
