import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import 'package:xnusa_mobile/widgets/user_post.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    final dashboardC = Get.put(DashboardController());
    final TextEditingController postController = TextEditingController();
    return Scaffold(
      backgroundColor: ColorApp.white,
      body: SafeArea(
        child: Column(
          children: [
            // Logo tetap di atas (tidak scroll)
            Container(
              color: ColorApp.white,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => dashboardC.changeIndex(1),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: SizeApp.w12),
                        child: Icon(
                          Icons.search,
                          color: ColorApp.primary,
                          size: SizeApp.h24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: SizeApp.w12),
                      child: Image.asset(
                        'assets/logo/XNusa.png',
                        height: SizeApp.h40,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => dashboardC.changeIndex(2),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: SizeApp.w12),
                        child: Icon(
                          Icons.map_outlined,
                          color: ColorApp.primary,
                          size: SizeApp.h24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Semua konten di bawah bisa scroll
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: ColorApp.primary),
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return PostField(
                        postController: postController,
                        controller: controller,
                      );
                    }

                    if (controller.posts.isEmpty && index == 1) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(child: Text("Belum ada postingan")),
                      );
                    }

                    final post = controller.posts[index - 1];

                    return UserPost(
                      post: post,
                      onTap:
                          () => controller.toggleLike(
                            controller.posts[index - 1],
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

class PostField extends StatelessWidget {
  const PostField({
    super.key,
    required this.postController,
    required this.controller,
  });

  final TextEditingController postController;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap.h12,
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeApp.h8,
            horizontal: SizeApp.w16,
          ),
          child: Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    controller.profileData['profile_image_url'] ??
                        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(controller.profileData['display_name'] ?? "User")}',
                  ),
                ),
                Gap.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You",
                        style: TypographyApp.textLight.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorApp.primary,
                          fontSize: SizeApp.h12,
                        ),
                      ),
                      Gap.h4,
                      TextField(
                        controller: postController,
                        minLines: 1,
                        maxLines: 6, // naik kebawah sampai 6 baris
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: "Apa yang kamu pikirkan?",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: ColorApp.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: ColorApp.primary),
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
        ),
        Divider(color: ColorApp.white1, thickness: 1),
      ],
    );
  }
}
