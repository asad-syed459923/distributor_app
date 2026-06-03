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

  Future<void> syncAttendance(AttendanceModel record) async {
    if (record.key == null) return;

    isSyncing.value = true;
    try {
      await _attendanceRepository.syncAttendance(record.key!);
      fetchHistory();
      Get.snackbar('Done', 'Synced', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSyncing.value = false;
    }
  }
}
