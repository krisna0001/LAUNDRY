import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:laundry3b1titik0/splash_screen.dart';
import 'package:laundry3b1titik0/services/theme_service.dart';
import 'package:laundry3b1titik0/models/weather_model.dart';
import 'package:laundry3b1titik0/models/forecast_model.dart';

void main() {
  // Pertahankan native splash selama inisialisasi
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Simulasi proses loading (opsional)
  Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find();

    return Obx(
      () => GetMaterialApp(
        title: 'Laundry 3B',
        theme: themeService.getLightTheme(),
        darkTheme: themeService.getDarkTheme(),
        themeMode:
            themeService.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
