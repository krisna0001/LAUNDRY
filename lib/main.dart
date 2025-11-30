import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:laundry3b1titik0/splash_screen.dart';
import 'package:laundry3b1titik0/services/theme_service.dart';
import 'package:laundry3b1titik0/models/weather_model.dart';
import 'package:laundry3b1titik0/models/forecast_model.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await Hive.initFlutter();

    // Registrasi adapter untuk model dengan typeId yang benar
    Hive.registerAdapter(WeatherModelAdapter());
    Hive.registerAdapter(MainDataAdapter());
    Hive.registerAdapter(WeatherDataAdapter());
    Hive.registerAdapter(WindDataAdapter());
    Hive.registerAdapter(ForecastModelAdapter());
    Hive.registerAdapter(ForecastItemAdapter());

    await Supabase.initialize(
      url: 'https://gozewnowaiddmlvjvffu.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdvemV3bm93YWlkZG1sdmp2ZmZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI3NjU4MTEsImV4cCI6MjA3ODM0MTgxMX0.C8tC1RN4HssBtN-pW3QvOaYa94TrPuHIohd21TE__ME',
    );

    await Get.putAsync(() => ThemeService().init());

    FlutterNativeSplash.remove();
  } catch (e) {
    print('Error during initialization: $e');
    FlutterNativeSplash.remove();
  }

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
