import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://krfnlfcadtyzslylzkia.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtyZm5sZmNhZHR5enNseWx6a2lhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA0NDgwMDYsImV4cCI6MjA3NjAyNDAwNn0.dIdwaQUOUEEn3Ev675WZfbi6NiNl0FWVX0rgWU_b3HQ',
  );
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
