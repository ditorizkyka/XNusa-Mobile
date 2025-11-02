import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/auth/controllers/auth_controller.dart';
import '../controllers/profile_page_controller.dart';

class ProfilePageView extends GetView<ProfilePageController> {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfilePageController());
    final authC = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.profileData;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto profil
              GestureDetector(
                onTap: () => controller.uploadProfileImage(),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      (data['profile_image_url'] != null)
                          ? NetworkImage(data['profile_image_url'])
                          : null,
                  child:
                      data['profile_image_url'] == null
                          ? const Icon(Icons.camera_alt, size: 40)
                          : null,
                ),
              ),
              const SizedBox(height: 20),

              // Username
              Text(
                data['username'] ?? 'No Username',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Display Name
              Text(
                data['display_name'] ?? '-',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),

              const SizedBox(height: 16),

              // Bio
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data['bio']?.isNotEmpty == true
                      ? data['bio']
                      : "Belum ada bio",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 24),

              // Tombol logout
              ElevatedButton.icon(
                onPressed: () async {
                  await authC.signOut();
                  Get.offAllNamed('/signin');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
