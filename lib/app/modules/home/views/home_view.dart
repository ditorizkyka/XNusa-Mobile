import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final TextEditingController postController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Timeline'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Field post baru
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: postController,
                      decoration: const InputDecoration(
                        hintText: "Apa yang kamu pikirkan?",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      if (postController.text.isNotEmpty) {
                        controller.addPost(postController.text);
                        postController.clear();
                      } else {
                        Get.snackbar(
                          "Gagal",
                          "Isi postingan dulu!",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 List Post (Obx)
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.posts.isEmpty) {
                  return const Center(child: Text("Belum ada postingan"));
                }

                return ListView.builder(
                  itemCount: controller.posts.length,
                  itemBuilder: (context, index) {
                    final post = controller.posts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundImage:
                                      post.profileImageUrl != null
                                          ? NetworkImage(post.profileImageUrl!)
                                          : const AssetImage(
                                                'assets/profile_placeholder.png',
                                              )
                                              as ImageProvider,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  post.username ?? "Anonim",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(post.description),
                            const SizedBox(height: 5),
                            Text(
                              post.createdAt.toLocal().toString().substring(
                                0,
                                16,
                              ),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
