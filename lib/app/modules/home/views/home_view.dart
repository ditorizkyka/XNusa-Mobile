import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/auth/controllers/auth_controller.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('HomeView'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('HomeView is working', style: TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/profile-page');
              },
              child: Text("Go to Profile"),
            ),
            ElevatedButton(
              onPressed: () {
                authC.signOut();
              },
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
