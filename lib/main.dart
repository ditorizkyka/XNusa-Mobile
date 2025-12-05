import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/data/models/userModel.dart';
import 'package:xnusa_mobile/shared/constanta.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Supabase.initialize(
    url: 'https://krfnlfcadtyzslylzkia.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtyZm5sZmNhZHR5enNseWx6a2lhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA0NDgwMDYsImV4cCI6MjA3NjAyNDAwNn0.dIdwaQUOUEEn3Ev675WZfbi6NiNl0FWVX0rgWU_b3HQ',
  );
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Error loading .env file: $e');
  }

  Hive.registerAdapter(UserModelAdapter());
  box = await Hive.openBox('userBox');

  bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);
  var initialRoute = isLoggedIn ? '/dashboard' : '/signin';
  print('isLoggedIn: $isLoggedIn');
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            initialRoute: initialRoute,
            getPages: AppPages.routes,
          ),
    ),
  );
}
