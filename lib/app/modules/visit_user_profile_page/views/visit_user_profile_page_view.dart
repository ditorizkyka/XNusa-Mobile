// 📁 File: visit_user_profile_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/visit_user_profile_page/controllers/visit_user_profile_page_controller.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import 'package:xnusa_mobile/widgets/user_post.dart';

class VisitUserProfileView extends GetView<VisitUserProfileController> {
  const VisitUserProfileView({super.key});

  // 🔹 Fungsi helper untuk truncate text
  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    // Get user ID dari arguments
    final String userId = Get.arguments as String;

    // Initialize controller dengan userId
    Get.lazyPut(() => VisitUserProfileController(userId: userId));

    return Scaffold(
      backgroundColor: ColorApp.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = controller.userData.value;

          return Column(
            children: [
              // ✅ AppBar dengan back button
              AppBarVisitProfile(),

              // ✅ Bagian profil user
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
                              // Display Name
                              Text(
                                truncateText(
                                  data["display_name"] ?? "User",
                                  14,
                                ),
                                style: TypographyApp.headline1,
                              ),
                              Gap.h4,

                              // Username & Copy URL
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      truncateText(
                                        "@${data["username"] ?? "username"}",
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
                                          text: "xnusa/id/${data["username"]}",
                                        ),
                                      );
                                      Get.snackbar(
                                        'Copied!',
                                        'Profile URL copied to clipboard',
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: const Duration(seconds: 2),
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
                                        borderRadius: BorderRadius.circular(20),
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

                              // Bio
                              if (data["bio"] != null &&
                                  data["bio"].toString().isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      truncateText(data["bio"], 100),
                                      style: TypographyApp.textLight.copyWith(
                                        color: ColorApp.darkGrey,
                                        fontSize: SizeApp.customHeight(9),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Gap.h12,
                                  ],
                                ),

                              // Followers info
                              UserFollowersRow(data: data),
                            ],
                          ),
                        ),
                        Gap.w8,

                        // Profile Avatar
                        CircleAvatar(
                          radius: SizeApp.h36,
                          backgroundColor: ColorApp.grey,
                          backgroundImage:
                              (data["profile_image_url"] != null)
                                  ? NetworkImage(data["profile_image_url"])
                                  : null,
                          child:
                              (data["profile_image_url"] == null)
                                  ? Icon(
                                    Icons.person,
                                    size: SizeApp.h36,
                                    color: Colors.white,
                                  )
                                  : null,
                        ),
                      ],
                    ),
                    Gap.h16,

                    // Follow/Unfollow Button
                    Obx(() {
                      final isFollowed = controller.isFollowed.value;
                      return GestureDetector(
                        onTap: () => controller.toggleFollow(),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: SizeApp.h12),
                          decoration: BoxDecoration(
                            color:
                                isFollowed
                                    ? ColorApp.lightGrey
                                    : ColorApp.primary,
                            borderRadius: BorderRadius.circular(SizeApp.h8),
                            border: Border.all(
                              color:
                                  isFollowed ? ColorApp.grey : ColorApp.primary,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              isFollowed ? "Following" : "Follow",
                              style: TypographyApp.textLight.copyWith(
                                fontSize: SizeApp.h12,
                                fontWeight: FontWeight.w600,
                                color:
                                    isFollowed ? ColorApp.grey : ColorApp.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              Divider(color: ColorApp.grey.withOpacity(0.3), thickness: 1),

              // ✅ Label "Posts"
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeApp.w16,
                  vertical: SizeApp.h8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Posts",
                    style: TypographyApp.textLight.copyWith(
                      fontSize: SizeApp.h12,
                      fontWeight: FontWeight.bold,
                      color: ColorApp.primary,
                    ),
                  ),
                ),
              ),

              // ✅ List of user posts
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingPosts.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.userPosts.isEmpty) {
                    return Center(
                      child: Text(
                        "Belum ada post.",
                        style: TypographyApp.textLight.copyWith(
                          color: ColorApp.grey,
                          fontSize: SizeApp.h12,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.userPosts.length,
                    itemBuilder: (context, index) {
                      final post = controller.userPosts[index];
                      return UserPost(
                        post: post,
                        onTap: () => controller.toggleLike(post),
                      );
                    },
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class AppBarVisitProfile extends StatelessWidget {
  const AppBarVisitProfile({super.key});

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
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back, size: SizeApp.h20),
            ),
            Row(children: [Icon(Icons.more_horiz, size: SizeApp.h20)]),
          ],
        ),
      ),
    );
  }
}

class UserFollowersRow extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  const UserFollowersRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final username = data["username"] ?? "";
    final profileUrl = "xnusa.id/$username";

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
        Text(
          '${data["followers_count"] ?? 0} followers',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
