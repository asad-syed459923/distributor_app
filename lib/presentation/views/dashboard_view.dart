import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../data/models/distributor_model.dart';
import '../../data/models/route_model.dart';
import 'package:intl/intl.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DashboardController>()) {
      Get.put(DashboardController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF1E234C)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Color(0xFF1E234C), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF1E234C)),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const Drawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Obx(() => Text(
              'Good Morning, ${controller.user.value?.name ?? 'User'}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E234C),
              ),
            )),
            Text(
              DateFormat('EEEE, MMM d, yyyy').format(DateTime.now()),
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // Progress Card (Dummy placeholder for illustration)
            _buildProgressCard(),
            const SizedBox(height: 24),

            // Attendance Card
            _buildAttendanceCard(),
            const SizedBox(height: 24),

            // Selection Dropdowns
            const Text(
              'SELECT DISTRIBUTOR',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            _buildDistributorDropdown(),
            const SizedBox(height: 16),
            const Text(
              'SELECT ROUTE',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            _buildRouteDropdown(),
            const SizedBox(height: 80), // Space for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: 0.5,
                    strokeWidth: 8,
                    backgroundColor: Color(0xFFF0F0F0),
                    color: Color(0xFF00BFA5),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('TOTAL SHOPS', style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                    Text('25/50', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E234C))),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                _buildStatRow('Total Deliveries', '25', const Color(0xFF00BFA5)),
                const Divider(height: 16, color: Color(0xFFF5F5F5)),
                _buildStatRow('Completed', '18', const Color(0xFF1E234C)),
                const Divider(height: 16, color: Color(0xFFF5F5F5)),
                _buildStatRow('Pending Shops', '12', Colors.orange),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E234C))),
      ],
    );
  }

  Widget _buildAttendanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Attendance',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E234C)),
              ),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: controller.isCheckedIn.value ? const Color(0xFFE0F2F1) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.isCheckedIn.value ? 'Online' : 'Inactive',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: controller.isCheckedIn.value ? const Color(0xFF00BFA5) : Colors.grey,
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Obx(() => Text(
                controller.lastAttendanceTime.value.isEmpty ? '--:--' : controller.lastAttendanceTime.value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E234C)),
              )),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
              onPressed: (controller.isLoading.value || controller.isLocationLoading.value) 
                  ? null 
                  : controller.handleAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: controller.isLocationLoading.value
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      controller.isCheckedIn.value ? 'Check Out Now' : 'Check In Now',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributorDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<DistributorModel>(
          value: controller.selectedDistributor.value,
          hint: const Text('Select Distributor', style: TextStyle(color: Colors.grey, fontSize: 13)),
          isExpanded: true,
          items: controller.distributors.map((dist) {
            return DropdownMenuItem(
              value: dist,
              child: Text(dist.name, style: const TextStyle(fontSize: 13)),
            );
          }).toList(),
          onChanged: controller.onDistributorChanged,
        ),
      )),
    );
  }

  Widget _buildRouteDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<RouteModel>(
          value: controller.selectedRoute.value,
          hint: const Text('Select Route', style: TextStyle(color: Colors.grey, fontSize: 13)),
          isExpanded: true,
          items: controller.routes.map((route) {
            return DropdownMenuItem(
              value: route,
              child: Text(route.name, style: const TextStyle(fontSize: 13)),
            );
          }).toList(),
          onChanged: controller.onRouteChanged,
        ),
      )),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E234C),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        currentIndex: 0,
        onTap: (index) {
          if (index == 3) Get.toNamed('/history');
          if (index == 2) Get.toNamed('/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Route'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
