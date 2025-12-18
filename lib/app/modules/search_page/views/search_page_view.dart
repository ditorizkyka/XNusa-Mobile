import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import '../controllers/search_page_controller.dart';

class SearchPageView extends GetView<SearchPageController> {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppbarSearchPage(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: SizeApp.customWidth(200),
                    decoration: BoxDecoration(
                      color: ColorApp.lightGrey,
                      borderRadius: BorderRadius.circular(SizeApp.h12),
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: SizeApp.w8,
                      horizontal: SizeApp.h16,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: SizeApp.h4,
                      horizontal: SizeApp.w16,
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Cari user",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: ColorApp.grey,
                        ),
                      ),
                      onChanged: (value) {
                        controller.searchUser(value);
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.searchUser(searchController.text);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: SizeApp.w16),
                    child: Icon(
                      Icons.search_rounded,
                      size: SizeApp.h24,
                      color: ColorApp.grey,
                    ),
                  ),
                ),
              ],
            ),
            Gap.h16,
            Expanded(
              child: Obx(() {
                if (controller.searchResults.isEmpty) {
                  return Center(
                    child: Text(
                      "Tidak ada hasil.",
                      style: TypographyApp.textLight.copyWith(
                        color: ColorApp.grey,
                        fontSize: SizeApp.h12,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final user = controller.searchResults[index];
                    return ResultSearch(user: user);
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

class ResultSearch extends StatelessWidget {
  final Map<String, dynamic> user;

  const ResultSearch({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 🔥 Navigate ke halaman profil user dengan userId
        Get.toNamed('/visit-user-profile-page', arguments: user['id']);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeApp.w16,
          vertical: SizeApp.h8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage:
                  user['profile_image_url'] != null
                      ? NetworkImage(user['profile_image_url'])
                      : const AssetImage('assets/profile_placeholder.png')
                          as ImageProvider,
            ),
            Gap.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['display_name'] ?? 'Tanpa Nama',
                    style: TypographyApp.textLight.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorApp.primary,
                      fontSize: SizeApp.h12,
                    ),
                  ),
                  Gap.h4,
                  Text(
                    '@${user['username']}',
                    style: TypographyApp.textLight.copyWith(
                      fontSize: SizeApp.h12,
                      color: ColorApp.grey,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Prevent navigation when clicking follow button
                final controller = Get.find<SearchPageController>();
                controller.toggleFollow(user['id']);
              },
              child: Container(
                decoration: BoxDecoration(
                  color:
                      (user['is_followed'] ?? false)
                          ? ColorApp.lightGrey
                          : ColorApp.primary,
                  borderRadius: BorderRadius.circular(SizeApp.h8),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: SizeApp.h4,
                  horizontal: SizeApp.w12,
                ),
                child: Text(
                  (user['is_followed'] ?? false) ? "Following" : "Follow",
                  style: TypographyApp.textLight.copyWith(
                    fontSize: SizeApp.h12,
                    color:
                        (user['is_followed'] ?? false)
                            ? ColorApp.grey
                            : ColorApp.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppbarSearchPage extends StatelessWidget {
  const AppbarSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeApp.w16,
        vertical: SizeApp.h12,
      ),
      child: Row(
        children: [Text("Search User", style: TypographyApp.headline1)],
      ),
    );
  }
}
