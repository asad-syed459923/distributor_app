import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = Get.find<AuthRepository>();
    final user = authRepo.getUser();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Color(0xFF1E234C), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E234C)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileHeader(user),
            const SizedBox(height: 24),
            _buildSectionHeader('APP & COMPANY'),
            _buildInfoTile(Icons.business, 'Company Name', 'Laziza Foods'),
            _buildInfoTile(Icons.vibration, 'App Version', '1.0.13'),
            const SizedBox(height: 24),
            _buildSectionHeader('WORK INFORMATION'),
            _buildInfoTile(Icons.badge_outlined, 'Employee ID', user?.employeeId ?? '-'),
            _buildInfoTile(Icons.category_outlined, 'Department', user?.department ?? '-'),
            _buildInfoTile(Icons.calendar_today_outlined, 'Date Of Joining', user?.joiningDate ?? '-'),
            const SizedBox(height: 24),
            _buildSectionHeader('CONTACT'),
            _buildInfoTile(Icons.phone_outlined, 'Phone', user?.phone ?? '-'),
            _buildInfoTile(Icons.email_outlined, 'Email', user?.email ?? '-'),
            
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await authRepo.logout();
                Get.offAllNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel? user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BFA5), Color(0xFF009688)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: user?.profileImage != null 
                ? Image.network(user!.profileImage!, width: 70, height: 70, fit: BoxFit.cover)
                : const Icon(Icons.person, size: 40, color: Color(0xFF00BFA5)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'User',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.designation ?? 'Designation',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  'ID: ${user?.employeeId ?? '---'}',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF00BFA5)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E234C))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
