import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<HistoryController>()) {
      Get.put(HistoryController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Attendance History', style: TextStyle(color: Color(0xFF1E234C), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E234C)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.attendanceHistory.isEmpty) {
          return const Center(child: Text('No attendance records found.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.attendanceHistory.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final record = controller.attendanceHistory[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: record.type == 'in' ? const Color(0xFFE0F2F1) : const Color(0xFFFFEBEE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      record.type == 'in' ? Icons.login : Icons.logout,
                      color: record.type == 'in' ? const Color(0xFF00BFA5) : Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Check-${record.type.capitalizeFirst}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E234C)),
                        ),
                        Text(
                          record.dateTime,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Distributor ID: ${record.distributorId} | Route ID: ${record.routeId}',
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: record.isSynced ? const Color(0xFFE0F2F1) : const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          record.isSynced ? 'Synced' : 'Pending',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: record.isSynced ? const Color(0xFF00BFA5) : Colors.orange,
                          ),
                        ),
                      ),
                      if (!record.isSynced)
                        TextButton(
                          onPressed: controller.isSyncing.value ? null : () => controller.syncAttendance(index),
                          child: const Text('POST', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF00BFA5))),
                        ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
