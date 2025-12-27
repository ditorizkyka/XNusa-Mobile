import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';
import 'package:xnusa_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:xnusa_mobile/app/modules/profile_page/controllers/follow_controller.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import 'package:xnusa_mobile/widgets/dialog/confirm_button_dialog.dart';

class UserPost extends StatelessWidget {
  UserPost({super.key, required this.post, required this.onTap});

  final PostModel post;
  final Function()? onTap;

  // NOTE: idealnya inject di binding/parent, tapi kita keep sesuai strukturmu.
  final followC = Get.put(FollowController());
  final homeC = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    final hasComments = post.commentCount > 0;
    final avatars = post.replyAvatarUrls; // ✅ max 2 avatar dari fetchPosts

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
                                post.profileImageUrl ??
                                    'https://ui-avatars.com/api/?name=${Uri.encodeComponent(post.displayName ?? "User")}',
                              ),
                            ),

                            // tombol follow
                            if (!isFollowed && post.userId != user?.id)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
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

                      // ✅ Garis thread + avatar repliers HANYA kalau ada comment
                      if (hasComments) ...[
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

                        // ✅ Avatar repliers (0/1/2)
                        _ReplierAvatars(avatars: avatars),
                      ],
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
                            Row(
                              children: [
                                Text(
                                  post.username ?? "Anonim",
                                  style: TypographyApp.textLight.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ColorApp.primary,
                                    fontSize: SizeApp.h12,
                                  ),
                                ),
                                if (post.isVerified) ...[
                                  Gap.w8,
                                  Icon(
                                    Icons.verified,
                                    size: SizeApp.h16,
                                    color:
                                        Colors.blue, // atau biru kalau kamu mau
                                  ),
                                ],
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  timeAgo(post.createdAt),
                                  style: TypographyApp.textLight.copyWith(
                                    fontSize: SizeApp.h12,
                                    color: ColorApp.grey,
                                  ),
                                ),
                                Gap.w12,
                                GestureDetector(
                                  onTap: () async {
                                    Get.dialog(
                                      ConfirmButtonDialog(
                                        title: 'Report Post',
                                        description:
                                            'Are you sure you want to report this post?',
                                        buttonText: 'Report',
                                        onConfirm: () async {
                                          Get.back(); // ✅ tutup dialog dulu
                                          await homeC.reportPost(post.id ?? 0);
                                        },
                                      ),
                                      barrierDismissible: true,
                                    );
                                  },

                                  child: Icon(
                                    Icons.report_gmailerrorred_sharp,
                                    color: ColorApp.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Gap.h4,

                        Text(
                          post.description ?? "",
                          style: TypographyApp.textLight.copyWith(
                            fontWeight: FontWeight.normal,
                            color: ColorApp.primary,
                            fontSize: SizeApp.h12,
                          ),
                        ),

                        Gap.h12,

                        // ✅ ABSORBER: supaya tap tombol tidak naik ke parent (navigate)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {},
                          child: Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
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
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  // opsional: langsung buka reply page
                                  Get.toNamed(
                                    "/reply-post-page",
                                    arguments: post,
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/comment.svg',
                                  width: SizeApp.w20,
                                  height: SizeApp.w20,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Gap.h12,

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

  String timeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    if (dateTime.isAfter(now)) return 'now';

    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';

    final weeks = (diff.inDays / 7).floor();
    if (weeks < 4) return '${weeks}w';

    final months = (diff.inDays / 30).floor();
    if (months < 12) return '${months}mo';

    final years = (diff.inDays / 365).floor();
    return '${years}y';
  }
}

/// ✅ Widget avatar repliers (max 2).
/// - 0 avatar => shrink
/// - 1 avatar => tampil 1
/// - >=2 => tampil 2 pertama
class _ReplierAvatars extends StatelessWidget {
  const _ReplierAvatars({required this.avatars});

  final List<String> avatars;

  @override
  Widget build(BuildContext context) {
    if (avatars.isEmpty) return const SizedBox.shrink();

    // maksimal 2
    final shown = avatars.length >= 2 ? avatars.take(2).toList() : avatars;

    // ✅ kalau cuma 1, center
    if (shown.length == 1) {
      return SizedBox(
        width: 36,
        height: 20,
        child: Center(child: _MiniAvatar(url: shown[0])),
      );
    }

    // ✅ kalau 2, pakai stack seperti biasa
    return SizedBox(
      width: 36,
      height: 20,
      child: Stack(
        children: [
          Positioned(left: 0, child: _MiniAvatar(url: shown[0])),
          Positioned(left: 12, child: _MiniAvatar(url: shown[1])),
        ],
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  const _MiniAvatar({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ColorApp.white, width: 1.5),
      ),
      child: CircleAvatar(radius: 8, backgroundImage: NetworkImage(url)),
    );
  }
}
