import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    final TextEditingController postController = TextEditingController();

    return Scaffold(
      backgroundColor: ColorApp.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: ColorApp.white,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(SizeApp.w12),
                  child: Image.asset('assets/logo/xn.png', height: SizeApp.h40),
                ),
              ),
            ), // Status bar color
            // 🔹 Field post baru (Fixed position at top)
            PostField(postController: postController, controller: controller),

            // 🔹 List Post (Scrollable)
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
                    return UserPost(post: post);
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
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeApp.h12,
            horizontal: SizeApp.w16,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage:
                    const AssetImage('assets/profile_placeholder.png')
                        as ImageProvider,
              ),
              Gap.w12,
              Column(
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
                  SizedBox(
                    width: SizeApp.customWidth(200),
                    height: SizeApp.h40,
                    child: TextField(
                      controller: postController,
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
                  ),
                  Gap.h12,
                ],
              ),

              Spacer(),
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
      ],
    );
  }
}

class UserPost extends StatelessWidget {
  const UserPost({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeApp.h12,
            horizontal: SizeApp.w16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage:
                    post.profileImageUrl != null
                        ? NetworkImage(post.profileImageUrl!)
                        : const AssetImage('assets/profile_placeholder.png')
                            as ImageProvider,
              ),
              Gap.w12,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.username ?? "Anonim",
                    style: TypographyApp.textLight.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorApp.primary,
                      fontSize: SizeApp.h12,
                    ),
                  ),
                  Gap.h4,
                  Text(
                    post.description,
                    style: TypographyApp.textLight.copyWith(
                      fontWeight: FontWeight.normal,
                      color: ColorApp.primary,
                      fontSize: SizeApp.h12,
                    ),
                  ),
                  Gap.h12,
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/like.svg',
                        width: SizeApp.w20,
                        height: SizeApp.w20,
                        fit: BoxFit.contain,
                      ),

                      Gap.w16,
                      SvgPicture.asset(
                        'assets/icons/comment.svg',
                        width: SizeApp.w20,
                        height: SizeApp.w20,
                        fit: BoxFit.contain,
                      ),
                      Gap.w16,
                      SvgPicture.asset(
                        'assets/icons/repost.svg',
                        width: SizeApp.w20,
                        height: SizeApp.w20,
                        fit: BoxFit.contain,
                      ),
                      Gap.w16,
                      SvgPicture.asset(
                        'assets/icons/share.svg',
                        width: SizeApp.w20,
                        height: SizeApp.w20,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  Gap.h12,
                  Row(
                    children: [
                      Text(
                        "26 Replies",
                        style: TypographyApp.textLight.copyWith(
                          fontSize: SizeApp.h12,
                          color: ColorApp.grey,
                        ),
                      ),
                      Gap.w12,
                      Text(
                        "26 Replies",
                        style: TypographyApp.textLight.copyWith(
                          fontSize: SizeApp.h12,
                          color: ColorApp.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Text(
                "2h",
                style: TypographyApp.textLight.copyWith(
                  fontSize: SizeApp.h12,
                  color: ColorApp.grey,
                ),
              ),
              Gap.w12,
              Icon(Icons.more_horiz, color: ColorApp.primary),
            ],
          ),
        ),
        Divider(color: ColorApp.white1),
      ],
    );
  }
}
