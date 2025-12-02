import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/data/models/reply_model.dart';
import 'package:xnusa_mobile/app/modules/profile_page/controllers/follow_controller.dart';
import 'package:xnusa_mobile/constant/constant.dart';

class UserReply extends StatelessWidget {
  UserReply({super.key, required this.reply});

  final ReplyModel reply;

  final followC = Get.put(FollowController());

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    // ✅ pakai find saja di sini
    // ✅ ambil status dari Supabase

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeApp.h8,
              horizontal: SizeApp.w16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Obx(() {
                      final isFollowed = followC.isFollowed(reply.userId);
                      return Stack(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              reply.profileImageUrl,
                            ),
                          ),
                          if (!isFollowed && reply.userId != user?.id)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap:
                                    () =>
                                        followC.toggleFollowUser(reply.userId),
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
                  ],
                ),
                Gap.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            reply.username,
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
                      Text(
                        reply.content,
                        style: TypographyApp.textLight.copyWith(
                          fontWeight: FontWeight.normal,
                          color: ColorApp.primary,
                          fontSize: SizeApp.h12,
                        ),
                      ),
                      Gap.h4,
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: ColorApp.white1, thickness: 1),
        ],
      ),
    );
  }
}
