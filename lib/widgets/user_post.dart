import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';
import 'package:xnusa_mobile/app/modules/profile_page/controllers/follow_controller.dart';
import 'package:xnusa_mobile/app/modules/reply_post_page/controllers/reply_post_page_controller.dart';
import 'package:xnusa_mobile/constant/constant.dart';

class UserPost extends StatelessWidget {
  UserPost({super.key, required this.post, required this.onTap});

  final PostModel post;
  final Function()? onTap;
  final followC = Get.put(FollowController());
  final replyC = Get.put(ReplyPostPageController());

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    final replies = replyC.replies.length;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.toNamed("/reply-post-page", arguments: post),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeApp.h8,
              horizontal: SizeApp.w16,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Avatar & Thread Line
                  Column(
                    children: [
                      // Profile Avatar dengan Follow Button
                      Obx(() {
                        final isFollowed = followC.isFollowed(
                          post.userId ?? '',
                        );
                        return Stack(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(
                                post.profileImageUrl ?? '',
                              ),
                            ),
                            if (!isFollowed && post.userId != user?.id)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap:
                                      () => followC.toggleFollowUser(
                                        post.userId ?? '',
                                      ),
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: ColorApp.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),

                      Gap.h8,

                      // Garis vertikal yang menyesuaikan tinggi konten
                      Expanded(
                        child: Container(
                          width: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ColorApp.grey.withOpacity(0.3),
                                ColorApp.grey.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Gap.h8,

                      // Avatar Repliers
                      SizedBox(
                        width: 36,
                        height: 20,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorApp.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundImage: NetworkImage(
                                    'https://i.pravatar.cc/150?img=1',
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 12,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorApp.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundImage: NetworkImage(
                                    'https://i.pravatar.cc/150?img=2',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Gap.w12,

                  // Right side - Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              post.username ?? "Anonim",
                              style: TypographyApp.textLight.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ColorApp.primary,
                                fontSize: SizeApp.h12,
                              ),
                            ),
                            Row(
                              children: [
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
                          ],
                        ),

                        Gap.h4,

                        // Post Description
                        Text(
                          post.description ?? "",
                          style: TypographyApp.textLight.copyWith(
                            fontWeight: FontWeight.normal,
                            color: ColorApp.primary,
                            fontSize: SizeApp.h12,
                          ),
                        ),

                        Gap.h12,

                        // Action Buttons
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

                        Gap.h12,

                        // Stats Row
                        Row(
                          children: [
                            Text(
                              "${post.likeCount} Likes",
                              style: TypographyApp.textLight.copyWith(
                                fontSize: SizeApp.h12,
                                color: ColorApp.grey,
                              ),
                            ),
                            Gap.w12,
                            Text(
                              "${post.commentCount} Comments",
                              style: TypographyApp.textLight.copyWith(
                                fontSize: SizeApp.h12,
                                color: ColorApp.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: ColorApp.white1, thickness: 1),
        ],
      ),
    );
  }
}
