import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/models/distributor_model.dart';
import '../../data/models/route_model.dart';
import '../../data/models/attendance_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../core/utils/location_service.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final AttendanceRepository _attendanceRepository = Get.find<AttendanceRepository>();
  final LocationService _locationService = Get.find<LocationService>();

  var user = Rxn<UserModel>();
  var distributors = <DistributorModel>[].obs;
  var routes = <RouteModel>[].obs;

  var selectedDistributor = Rxn<DistributorModel>();
  var selectedRoute = Rxn<RouteModel>();

  var isLoading = false.obs;
  var isLocationLoading = false.obs;

  var isCheckedIn = false.obs;
  var lastAttendanceTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _authRepository.getUser();
    fetchDistributors();
    _loadCheckInState();
  }

  void _loadCheckInState() {
    isCheckedIn.value = _attendanceRepository.isCheckedIn();

    final time = _attendanceRepository.checkInTime();
    if (time != null && time.isNotEmpty) {
      lastAttendanceTime.value = time.contains(' ') ? time.split(' ')[1] : time;
      return;
    }

    final history = _attendanceRepository.getAttendanceHistory();
    if (history.isEmpty) return;

    final last = history.first;
    lastAttendanceTime.value = last.dateTime.split(' ')[1];
    isCheckedIn.value = last.type == 'in';
  }

  Future<void> fetchDistributors() async {
    isLoading.value = true;
    try {
      distributors.value = await _attendanceRepository.getDistributors();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRoutes(int distributorId) async {
    routes.clear();
    selectedRoute.value = null;
    try {
      routes.value = await _attendanceRepository.getRoutes(distributorId);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void onDistributorChanged(DistributorModel? distributor) {
    selectedDistributor.value = distributor;
    if (distributor != null) fetchRoutes(distributor.id);
  }

  void onRouteChanged(RouteModel? route) {
    selectedRoute.value = route;
  }

  Future<void> handleAttendance() async {
    if (selectedDistributor.value == null || selectedRoute.value == null) {
      Get.snackbar('Warning', 'Select a distributor and route first', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLocationLoading.value = true;
    try {
      final position = await _locationService.getCurrentLocation();
      final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      await _attendanceRepository.saveAttendance(AttendanceModel(
        dateTime: now,
        userId: user.value?.id ?? 0,
        latitude: position.latitude,
        longitude: position.longitude,
        distributorId: selectedDistributor.value!.id,
        routeId: selectedRoute.value!.id,
        type: isCheckedIn.value ? 'out' : 'in',
      ));

      isCheckedIn.value = !isCheckedIn.value;
      lastAttendanceTime.value = DateFormat('hh:mm a').format(DateTime.now());

      final label = isCheckedIn.value ? 'Checked in' : 'Checked out';
      Get.snackbar('Done', label, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLocationLoading.value = false;
    }
  }
}
