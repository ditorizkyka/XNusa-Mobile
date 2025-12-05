import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';
import 'package:xnusa_mobile/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:xnusa_mobile/app/modules/dashboard/views/dashboard_view.dart';
import 'package:xnusa_mobile/app/modules/explore_page/views/explore_page_view.dart';
import 'package:xnusa_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:xnusa_mobile/app/modules/home/views/home_view.dart';
import 'package:xnusa_mobile/app/modules/message_page/views/message_page_view.dart';
import 'package:xnusa_mobile/app/modules/profile_page/views/profile_page_view.dart';
import 'package:xnusa_mobile/app/modules/search_page/views/search_page_view.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import 'package:xnusa_mobile/widgets/user_reply.dart';

import '../controllers/reply_post_page_controller.dart';

class ReplyPostPageView extends GetView<ReplyPostPageController> {
  const ReplyPostPageView({super.key});
  @override
  Widget build(BuildContext context) {
    PostModel post = Get.arguments;
    final controller = Get.find<ReplyPostPageController>();
    final homeController = Get.put(HomeController());

    controller.fetchReplies(post.id ?? 0);

    return Scaffold(
      backgroundColor: ColorApp.white,
      bottomNavigationBar: DashboardNavBar(isSubPage: true),
      body: SafeArea(
        child: Column(
          children: [
            AppbarReplies(),
            // Semua konten di bawah bisa scroll
            Expanded(
              // child: Container(color: Colors.amber),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: ColorApp.primary),
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.replies.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return PostReplied(
                        post: post,
                        onTap: () {
                          homeController.toggleLike(post);
                        },
                      );
                    }

                    if (controller.replies.isEmpty && index == 1) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Text(
                            "There are no replies yet",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }

                    final reply = controller.replies[index - 1];

                    return UserReply(reply: reply);
                  },
                );
              }),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: SizeApp.w12,
                vertical: SizeApp.h16,
              ),
              decoration: BoxDecoration(
                color: ColorApp.lightGrey,
                borderRadius: BorderRadius.circular(SizeApp.h12),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeApp.w12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: SizeApp.h12,
                      backgroundImage: NetworkImage(
                        homeController.profileData['profile_image_url'] ??
                            'https://ui-avatars.com/api/?name=No+Image',
                      ),
                    ),
                    Gap.w8,
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // TextField
                          Expanded(
                            child: TextField(
                              controller: controller.replyController,
                              maxLength: 50,
                              maxLines: null,
                              style: TypographyApp.textLight.copyWith(
                                fontSize: SizeApp.h12,
                                color: ColorApp.darkGrey,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: 'Reply to ${post.username}...',
                                hintStyle: TypographyApp.textLight.copyWith(
                                  color: ColorApp.darkGrey,
                                  fontSize: SizeApp.h12,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          // 🔥 indikator karakter
                          Obx(() {
                            return Text(
                              "${controller.charCount.value}/50",
                              style: TypographyApp.textLight.copyWith(
                                color:
                                    controller.charCount.value >= 50
                                        ? Colors.red
                                        : ColorApp.darkGrey,
                                fontSize: SizeApp.h12,
                              ),
                            );
                          }),

                          Gap.w8,

                          GestureDetector(
                            onTap:
                                () => controller.submitReply(
                                  postId: post.id ?? 0,
                                ),
                            child: Icon(
                              Icons.send,
                              color:
                                  controller.charCount.value > 0
                                      ? ColorApp.primary
                                      : ColorApp.grey,
                              size: SizeApp.h16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Semua konten di bawah bisa scroll
            // Expanded(
            //   child: Obx(() {
            //     if (controller.isLoading.value) {
            //       return const Center(child: CircularProgressIndicator());
            //     }

            //     return ListView.builder(
            //       physics: const AlwaysScrollableScrollPhysics(),
            //       itemCount: controller.posts.length + 1,
            //       itemBuilder: (context, index) {
            //         if (index == 0) {
            //           return PostField(
            //             postController: postController,
            //             controller: controller,
            //           );
            //         }

            //         if (controller.posts.isEmpty && index == 1) {
            //           return const Padding(
            //             padding: EdgeInsets.all(20.0),
            //             child: Center(child: Text("Belum ada postingan")),
            //           );
            //         }

            //         final post = controller.posts[index - 1];

            //         return UserPost(
            //           post: post,
            //           onTap:
            //               () => controller.toggleLike(
            //                 controller.posts[index - 1],
            //               ),
            //         );
            //       },
            //     );
            //   }),
            // ),
          ],
        ),
      ),
    );
  }
}

class PostReplied extends StatelessWidget {
  const PostReplied({super.key, required this.post, this.onTap});

  final Function()? onTap;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: ColorApp.lightGrey),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeApp.h8,
            horizontal: SizeApp.w16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: SizeApp.h16,
                    backgroundImage: NetworkImage(
                      post.profileImageUrl ??
                          'https://ui-avatars.com/api/?name=No+Image',
                    ),
                  ),
                  Gap.w12,
                  Expanded(
                    child: Text(
                      post.username ?? '',
                      style: TypographyApp.headline1.copyWith(
                        fontSize: SizeApp.h12,
                      ),
                    ),
                  ),
                  Gap.w12,
                  Image.asset('assets/logo/xn.png', height: SizeApp.h20),
                ],
              ),
              Gap.h12,
              Text(
                post.description ?? '',
                style: TypographyApp.textLight.copyWith(
                  fontSize: SizeApp.h12,
                  color: ColorApp.primary,
                ),
              ),
              Gap.h12,
              Row(
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: SvgPicture.asset(
                      post.isLiked
                          ? 'assets/icons/liked.svg'
                          : 'assets/icons/like.svg',
                      width: SizeApp.w20,
                      height: SizeApp.w20,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Gap.w4,
                  Text(
                    ' ${post.likeCount} Likes',
                    style: TypographyApp.textLight.copyWith(
                      fontSize: SizeApp.h12,
                      color: ColorApp.darkGrey,
                    ),
                  ),
                  Gap.w16,
                  GestureDetector(
                    onTap: () {
                      print("you commented on the post ${post.id}");
                    },
                    child: SvgPicture.asset(
                      'assets/icons/comment.svg',
                      width: SizeApp.w20,
                      height: SizeApp.w20,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Gap.w4,
                  Text(
                    ' ${post.commentCount} Comments',
                    style: TypographyApp.textLight.copyWith(
                      fontSize: SizeApp.h12,
                      color: ColorApp.darkGrey,
                    ),
                  ),
                  Gap.w16,
                  GestureDetector(
                    onTap: () {
                      print(
                        "you reposted the post ${post.id} by ${post.username}",
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/icons/repost.svg',
                      width: SizeApp.w20,
                      height: SizeApp.w20,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: ColorApp.lightGrey),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeApp.w16),
          child: Row(
            children: [
              Text(
                'Top',
                style: TypographyApp.headline1.copyWith(
                  fontSize: SizeApp.customHeight(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap.w8,
              Icon(
                Icons.keyboard_arrow_down_outlined,
                size: SizeApp.h20,
                color: ColorApp.grey,
              ),
            ],
          ),
        ),
        Gap.h12,
      ],
    );
  }
}

class AppbarReplies extends StatelessWidget {
  const AppbarReplies({super.key});

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
              child: Icon(Icons.arrow_back, size: SizeApp.h24),
            ),
            Column(
              children: [
                Text(
                  'Replies',
                  style: TypographyApp.headline1.copyWith(
                    fontSize: SizeApp.customHeight(15),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  '12 Replies',
                  style: TypographyApp.label.copyWith(
                    fontSize: SizeApp.customHeight(10),
                    fontWeight: FontWeight.w400,
                    color: ColorApp.grey,
                  ),
                ),
              ],
            ),
            Icon(Icons.more_horiz_outlined, size: SizeApp.h24),
          ],
        ),
      ),
    );
  }
}
