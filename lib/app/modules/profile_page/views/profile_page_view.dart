import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/auth/controllers/auth_controller.dart';
import 'package:xnusa_mobile/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import 'package:xnusa_mobile/widgets/button_app_unfilled.dart';
import 'package:xnusa_mobile/widgets/dialog/choose_button_dialog.dart';
import 'package:xnusa_mobile/widgets/user_post.dart';
import '../controllers/profile_page_controller.dart';

class ProfilePageView extends GetView<ProfilePageController> {
  const ProfilePageView({super.key});

  // 🔹 Fungsi helper untuk truncate text
  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfilePageController());
    final authC = Get.put(AuthController());
    final dashboardC = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: ColorApp.white,
      body: SafeArea(
        child: Obx(() {
          final data = controller.profileData;
          final followersCount = controller.followersCount.value;
          final followers = controller.followers;

          return DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ✅ AppBar custom
                AppBarProfile(authC: authC, dashboardC: dashboardC),

                // ✅ Bagian profil
                if (controller.isLoading.value)
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: ColorApp.primary),
                    ),
                  )
                else
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          truncateText(
                                            data["display_name"] ??
                                                "display_name",
                                            20,
                                          ),
                                          style: TypographyApp.headline1,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),

                                      // ✅ tampilkan badge kalau verified
                                      if ((data["isVerified"] as bool?) ??
                                          false)
                                        Icon(
                                          Icons.verified,
                                          size: SizeApp.h16,
                                          color:
                                              Colors.blue, // atau Colors.blue
                                        ),
                                    ],
                                  ),

                                  Gap.h4,
                                  Row(
                                    children: [
                                      // 🔥 Username - max 15 char
                                      Flexible(
                                        child: Text(
                                          truncateText(
                                            data["username"] ?? "username",
                                            15,
                                          ),
                                          style: TypographyApp.label.copyWith(
                                            color: ColorApp.primary,
                                            fontSize: SizeApp.customHeight(10),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Gap.w8,
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text:
                                                  "xnusa/id/${data["username"]}",
                                            ),
                                          );
                                          Get.snackbar(
                                            'Copied!',
                                            'Profile URL copied to clipboard',

                                            duration: const Duration(
                                              seconds: 2,
                                            ),
                                            margin: EdgeInsets.all(16),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: SizeApp.w8,
                                            vertical: SizeApp.h4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Copy Profile URL",
                                                style: TypographyApp.textLight
                                                    .copyWith(
                                                      color: ColorApp.darkGrey,
                                                      fontSize: SizeApp.h8,
                                                    ),
                                              ),
                                              Gap.w4,
                                              Icon(
                                                Icons.copy_rounded,
                                                size: SizeApp.h8,
                                                color: ColorApp.darkGrey,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap.h12,
                                  // 🔥 Bio - max 100 char, max 2 lines
                                  if (data["bio"] != null &&
                                      data["bio"].toString().isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          truncateText(data["bio"], 100),
                                          style: TypographyApp.textLight
                                              .copyWith(
                                                color: ColorApp.darkGrey,
                                                fontSize: SizeApp.customHeight(
                                                  9,
                                                ),
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Gap.h12,
                                      ],
                                    ),
                                  FollowersRow(
                                    followerCount: followersCount,
                                    followers: followers,
                                  ),
                                ],
                              ),
                            ),
                            Gap.w8,
                            // Profile Avatar
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
                                  showChooseButtonDialog(
                                    title: "Sign out from this account?",
                                    description:
                                        "Are you sure you want to log out? You can always log back in later.",
                                    onDiscard: () => Get.back(),
                                    onSave: () async {
                                      await authC.signOut();
                                      Get.offAllNamed('/signin');
                                    },
                                    cancelText: "Cancel",
                                    confirmText: "Sign Out",
                                  );
                                },
                                title: "Sign Out",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // ✅ TabBar (hanya tampil jika tidak loading)
                if (!controller.isLoading.value)
                  TabBar(
                    indicatorColor: ColorApp.primary,
                    labelColor: ColorApp.primary,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [Tab(text: "Threads"), Tab(text: "Likes")],
                  ),

                // ✅ TabBarView (hanya tampil jika tidak loading)
                if (!controller.isLoading.value)
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab 1 → Threads user
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

                        // Tab 2 → Likes user
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (controller.userLikes.isEmpty) {
                            return const Center(
                              child: Text("Belum ada Likes."),
                            );
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
                      ],
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class AppBarProfile extends StatelessWidget {
  final DashboardController dashboardC;

  const AppBarProfile({
    required this.authC,
    required this.dashboardC,
    super.key,
  });

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
            GestureDetector(
              onTap: () => dashboardC.changeIndex(1),
              child: Icon(Icons.search, size: SizeApp.h20),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    showChooseButtonDialog(
                      title: "Sign out from this account?",
                      description:
                          "Are you sure you want to log out? You can always log back in later.",
                      onDiscard: () => Get.back(),
                      onSave: () async {
                        await authC.signOut();
                        Get.offAllNamed('/signin');
                      },
                      cancelText: "Cancel",
                      confirmText: "Sign Out",
                    );
                  },
                  child: Icon(Icons.logout_rounded, size: SizeApp.h20),
                ),
                Gap.w12,
                GestureDetector(
                  onTap: () => Get.toNamed('/edit-profile-page'),
                  child: Icon(Icons.settings_outlined, size: SizeApp.h20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FollowersRow extends StatelessWidget {
  final int followerCount;
  final List<Map<String, dynamic>> followers;

  const FollowersRow({
    super.key,
    required this.followerCount,
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfilePageController>();
    final username = controller.profileData["username"] ?? "";
    final profileUrl = "xnusa.id/$username";

    // ambil max 3 followers terbaru untuk preview avatar
    final previewFollowers = followers.take(3).toList();
    final showPlaceholder = previewFollowers.isEmpty;

    // jumlah avatar yang tampil (minimal 1 kalau placeholder)
    final avatarCount = showPlaceholder ? 1 : previewFollowers.length;

    // width stack dinamis agar tidak ada gap saat avatar cuma 1
    // diameter avatar = 30 (radius 15), overlap step = 20
    final stackWidth = 30.0 + (avatarCount - 1) * 20.0;

    return Row(
      children: [
        SizedBox(
          width: stackWidth,
          height: 30,
          child: Stack(
            children: [
              if (showPlaceholder)
                _buildAvatar(left: 0, imageUrl: null)
              else
                for (int i = 0; i < previewFollowers.length; i++)
                  _buildAvatar(
                    left: i * 20.0,
                    imageUrl: _getFollowerImageUrl(previewFollowers[i]),
                  ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$followerCount followers',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: profileUrl));
            Get.snackbar(
              'Copied!',
              'Profile URL copied to clipboard',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(16),
            );
          },
          child: Icon(Icons.copy_rounded, size: 18, color: ColorApp.darkGrey),
        ),
      ],
    );
  }

  /// Ambil image url dari struktur followers fetchFollowers():
  /// { 'profile': { 'profile_image_url': '...' } }
  String? _getFollowerImageUrl(Map<String, dynamic> followerRow) {
    final profile = followerRow['profile'];
    if (profile is Map<String, dynamic>) {
      final url = profile['profile_image_url'];
      if (url is String && url.trim().isNotEmpty) return url;
    }
    return null;
  }

  Widget _buildAvatar({required double left, required String? imageUrl}) {
    return Positioned(
      left: left,
      child: CircleAvatar(
        radius: 15,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 13,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
          child: imageUrl == null ? const Icon(Icons.person, size: 14) : null,
        ),
      ),
    );
  }
}
