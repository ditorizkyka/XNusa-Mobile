import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';
import 'package:xnusa_mobile/constant/constant.dart';

class UserPost extends StatelessWidget {
  const UserPost({super.key, required this.post, required this.onTap});

  final PostModel post;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  CircleAvatar(
                    radius: 18,
                    backgroundImage:
                        post.profileImageUrl != null
                            ? NetworkImage(post.profileImageUrl!)
                            : const AssetImage('assets/profile_placeholder.png')
                                as ImageProvider,
                  ),
                  Gap.h8,
                  Container(
                    width: 2,
                    height: 40,
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
                  Gap.h8,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Text(
                      post.description ?? "",
                      style: TypographyApp.textLight.copyWith(
                        fontWeight: FontWeight.normal,
                        color: ColorApp.primary,
                        fontSize: SizeApp.h12,
                      ),
                    ),
                    Gap.h12,
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onTap,
                          child: SvgPicture.asset(
                            'assets/icons/like.svg',
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
                          "26 Reposts",
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
        Divider(color: ColorApp.white1, thickness: 1),
      ],
    );
  }
}
