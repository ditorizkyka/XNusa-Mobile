import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/profile_page/controllers/profile_page_controller.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import '../controllers/edit_profile_page_controller.dart';

class EditProfilePageView extends GetView<EditProfilePageController> {
  const EditProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfilePageController());

    return Scaffold(
      backgroundColor: ColorApp.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: TypographyApp.label.copyWith(
              fontSize: SizeApp.h12,
              color: Colors.black,
            ),
          ),
        ),
        leadingWidth: 80,
        title: Text(
          'Edit profile',
          style: TypographyApp.headline1.copyWith(
            fontSize: SizeApp.customHeight(14),
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(
            () =>
                controller.isLoading.value
                    ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorApp.primary,
                        ),
                      ),
                    )
                    : TextButton(
                      onPressed: controller.saveProfile,
                      child: Text(
                        'Done',
                        style: TypographyApp.headline1.copyWith(
                          fontSize: SizeApp.customHeight(11),
                        ),
                      ),
                    ),
          ),
        ],
      ),

      // ---------------------------------------------------------
      // ⬇️ Body Tengah + Scrollable
      // ---------------------------------------------------------
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // MAIN CARD
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------------------------------------
                      // USERNAME + PHOTO
                      // ---------------------------------------
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: SizeApp.h8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Username',
                                    style: TypographyApp.label.copyWith(
                                      fontSize: SizeApp.customHeight(11),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Gap.h8,
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lock_outline_rounded,
                                        size: SizeApp.customHeight(14),
                                      ),
                                      Gap.w4,
                                      Expanded(
                                        child: Text(
                                          "${profileController.profileData['display_name']} (@${profileController.profileData['username']})",
                                          style: TypographyApp.label.copyWith(
                                            fontSize: SizeApp.h12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                profileController.pickAndUploadProfileImage();
                              },
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: SizeApp.customHeight(20),
                                    backgroundColor: ColorApp.grey,
                                    backgroundImage:
                                        (profileController
                                                    .profileData["profile_image_url"] !=
                                                null)
                                            ? NetworkImage(
                                              profileController
                                                  .profileData["profile_image_url"],
                                            )
                                            : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
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
                      ),

                      const Divider(),

                      // Display Name
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: SizeApp.h8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Display Name',
                              style: TypographyApp.label.copyWith(
                                fontSize: SizeApp.customHeight(11),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gap.h8,
                            TextField(
                              controller: controller.displayNameController,
                              keyboardType: TextInputType.text,
                              style: TypographyApp.label.copyWith(
                                fontSize: SizeApp.customHeight(11),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter your display name',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(),

                      // ADDRESS
                      Text(
                        'Address',
                        style: TypographyApp.label.copyWith(
                          fontSize: SizeApp.customHeight(11),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap.h8,
                      TextField(
                        controller: controller.addressController,
                        maxLines: 2,
                        style: TypographyApp.label.copyWith(
                          fontSize: SizeApp.customHeight(11),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter your address...',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),

                      const Divider(),

                      // ---------------------------------------
                      // BIO
                      // ---------------------------------------
                      Text(
                        'Bio',
                        style: TypographyApp.label.copyWith(
                          fontSize: SizeApp.customHeight(11),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.bioController,
                        maxLines: 3,
                        style: TypographyApp.label.copyWith(
                          fontSize: SizeApp.customHeight(11),
                          fontWeight: FontWeight.w300,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Write your bio...',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),

                      Divider(),

                      // ---------------------------------------
                      // LANGUAGE
                      // ---------------------------------------
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: SizeApp.h8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Language',
                              style: TypographyApp.label.copyWith(
                                fontSize: SizeApp.customHeight(11),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                ClipOval(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 10,
                                        color: Colors.red,
                                      ),
                                      Container(
                                        width: 20,
                                        height: 10,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                Gap.w8,
                                const Text(
                                  'ID Only',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Divider(),

                      // ---------------------------------------
                      // INSTAGRAM BADGE
                      // ---------------------------------------
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: SizeApp.h8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Show TrustNusa Badge',
                                    style: TypographyApp.label.copyWith(
                                      fontSize: SizeApp.customHeight(11),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Gap.h4,
                                  Text(
                                    'When turned off, the Threads badge on your Instagram profile will also disappear.',
                                    style: TypographyApp.label.copyWith(
                                      fontSize: SizeApp.customHeight(10),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(
                              () => Switch(
                                value: controller.showInstagramBadge.value,
                                onChanged: controller.toggleInstagramBadge,
                                activeColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(),

                      // ---------------------------------------
                      // TRUST NUSA VERIFIED BADGE
                      // ---------------------------------------
                      GestureDetector(
                        onTap: () => controller.navigateToRequestVerified(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: SizeApp.h8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Request TrustNusa Verified Badge',
                                      style: TypographyApp.label.copyWith(
                                        fontSize: SizeApp.customHeight(11),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Gap.h4,
                                    Text(
                                      'If you switch to private, only followers can see your threads. Your replies will be visible to followers and individual profiles you reply to.',
                                      style: TypographyApp.label.copyWith(
                                        fontSize: SizeApp.customHeight(10),
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap.w4,
                              const Row(
                                children: [
                                  Icon(Icons.chevron_right, color: Colors.grey),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Gap.h20,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
