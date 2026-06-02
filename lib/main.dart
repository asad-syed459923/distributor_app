import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/providers/hive_provider.dart';
import 'presentation/bindings/app_binding.dart';
import 'presentation/views/login_view.dart';
import 'presentation/views/dashboard_view.dart';
import 'presentation/views/history_view.dart';
import 'presentation/views/profile_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveProvider.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final hiveProvider = HiveProvider();
    final isLoggedIn = hiveProvider.isLoggedIn();

    return GetMaterialApp(
      title: 'Distributor App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.outfit().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BFA5),
          primary: const Color(0xFF00BFA5),
        ),
      ),
      initialBinding: AppBinding(),
      initialRoute: isLoggedIn ? '/dashboard' : '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginView()),
        GetPage(name: '/dashboard', page: () => const DashboardView()),
        GetPage(name: '/history', page: () => const HistoryView()),
        GetPage(name: '/profile', page: () => const ProfileView()),
      ],
    );
  }
}
