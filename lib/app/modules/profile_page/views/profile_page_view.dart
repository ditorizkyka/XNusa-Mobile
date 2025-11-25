import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/auth/controllers/auth_controller.dart';
import 'package:xnusa_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:xnusa_mobile/app/modules/profile_page/controllers/follow_controller.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import 'package:xnusa_mobile/widgets/button_app_unfilled.dart';
import 'package:xnusa_mobile/widgets/user_post.dart';
import '../controllers/profile_page_controller.dart';

class ProfilePageView extends GetView<ProfilePageController> {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfilePageController());
    final authC = Get.put(AuthController());
    final homeController = Get.put(HomeController());
    final followC = Get.put(FollowController());

    return Scaffold(
      backgroundColor: ColorApp.white,

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.profileData;
        print(controller.userLikes.length);
        return SafeArea(
          child: DefaultTabController(
            length: 2, // 👉 Threads & Replies
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ✅ AppBar custom
                AppBarProfile(authC: authC),

                // ✅ Bagian profil (foto, nama, bio, button)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeApp.h12,
                    horizontal: SizeApp.w16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["display_name"] ?? "display_name",
                                style: TypographyApp.headline1,
                              ),
                              Gap.h4,
                              Row(
                                children: [
                                  Text(
                                    data["username"] ?? "username",
                                    style: TypographyApp.label.copyWith(
                                      color: ColorApp.primary,
                                      fontSize: SizeApp.h12,
                                    ),
                                  ),
                                  Gap.w8,
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeApp.w8,
                                      vertical: SizeApp.h4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "xnusa/id/${data["username"]}",
                                      style: TypographyApp.textLight.copyWith(
                                        color: ColorApp.darkGrey,
                                        fontSize: SizeApp.h8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Gap.h12,
                              if (data["bio"] != null &&
                                  data["bio"].toString().isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: SizeApp.customWidth(240),
                                      child: Text(
                                        data["bio"],
                                        style: TypographyApp.textLight.copyWith(
                                          color: ColorApp.darkGrey,
                                          fontSize: SizeApp.customHeight(9),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ),
                                    Gap.h12,
                                  ],
                                ),
                              FollowersRow(),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              controller.pickAndUploadProfileImage();
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: SizeApp.h36,
                                  backgroundColor: ColorApp.grey,
                                  backgroundImage:
                                      (data["profile_image_url"] != null)
                                          ? NetworkImage(
                                            data["profile_image_url"],
                                          )
                                          : null,
                                ),

                                // 👉 Icon kamera / edit
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: ColorApp.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: SizeApp.h12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap.h16,
                      Row(
                        children: [
                          Expanded(
                            child: ButtonAppUnfilled(
                              onTap: () {
                                Get.toNamed('/edit-profile-page');
                              },
                              title: "Edit Profile",
                            ),
                          ),
                          Gap.w12,
                          Expanded(
                            child: ButtonAppUnfilled(
                              onTap: () async {
                                await authC.signOut();
                                Get.offAllNamed('/signin');
                              },
                              title: "Sign Out",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ✅ Tambahkan tab Threads dan Replies
                TabBar(
                  indicatorColor: ColorApp.primary,
                  labelColor: ColorApp.primary,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [Tab(text: "Threads"), Tab(text: "Likes")],
                ),

                // ✅ Isi tab-nya: Threads dan Replies
                Expanded(
                  child: TabBarView(
                    children: [
                      // // Tab 1 → Threads user
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.userPosts.isEmpty) {
                          return const Center(child: Text("Belum ada Post."));
                        }
                        return ListView.builder(
                          itemCount: controller.userPosts.length,
                          itemBuilder: (context, index) {
                            final post = controller.userPosts[index];
                            return UserPost(
                              post: post,
                              onTap:
                                  () => controller.toggleLike(
                                    controller.userPosts[index],
                                    controller.userPosts,
                                  ),
                            );
                          },
                        );
                      }),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.userLikes.isEmpty) {
                          return const Center(child: Text("Belum ada Likes."));
                        }
                        return ListView.builder(
                          itemCount: controller.userLikes.length,
                          itemBuilder: (context, index) {
                            final likes = controller.userLikes[index];

                            return UserPost(
                              post: likes,
                              onTap:
                                  () => controller.toggleLike(
                                    controller.userLikes[index],
                                    controller.userLikes,
                                  ),
                            );
                          },
                        );
                      }),

                      // // Tab 2 → Replies user
                      // Obx(() {
                      //   if (controller.isLoading.value) {
                      //     return const Center(child: CircularProgressIndicator());
                      //   }
                      //   if (controller.userReplies.isEmpty) {
                      //     return const Center(child: Text("Belum ada replies."));
                      //   }
                      //   return ListView.builder(
                      //     itemCount: controller.userReplies.length,
                      //     itemBuilder: (context, index) {
                      //       final reply = controller.userReplies[index];
                      //       return ReplyCard(reply: reply);
                      //     },
                      //   );
                      // }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class AppBarProfile extends StatelessWidget {
  const AppBarProfile({required this.authC, super.key});

  final AuthController authC;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorApp.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeApp.h12,
          horizontal: SizeApp.w16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.search, size: SizeApp.h20),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    await authC.signOut();
                    Get.offAllNamed('/signin');
                  },
                  child: Icon(Icons.logout_rounded, size: SizeApp.h20),
                ),
                Gap.w12,
                Icon(Icons.settings_outlined, size: SizeApp.h20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FollowersRow extends StatelessWidget {
  const FollowersRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Stack of avatars
        SizedBox(
          width: 70,
          height: 30,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=1',
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=2',
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 40,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=3',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Text info
        const Text(
          '412 k followers',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 4),
        const Text('•', style: TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(width: 4),
        const Text(
          'fb.com',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
