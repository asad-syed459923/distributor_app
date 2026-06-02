import 'package:get/get.dart';
import '../../data/models/attendance_model.dart';
import '../../data/repositories/attendance_repository.dart';

class HistoryController extends GetxController {
  final AttendanceRepository _attendanceRepository = Get.find<AttendanceRepository>();

  var attendanceHistory = <AttendanceModel>[].obs;
  var isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void fetchHistory() {
    attendanceHistory.value = _attendanceRepository.getAttendanceHistory();
  }

  Future<void> syncAttendance(int index) async {
    isSyncing.value = true;
    try {
      // Simple approach: sync by finding the object
      await _attendanceRepository.syncAttendance(index); // This index should be correct if it matches the box index
      
      fetchHistory();
      Get.snackbar('Success', 'Attendance synced successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSyncing.value = false;
    }
  }
}
