import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/search_page/controllers/search_page_controller.dart';
import 'package:xnusa_mobile/constant/constant.dart';

class MessagePageView extends GetView<SearchPageController> {
  const MessagePageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppbarMessagesPage(),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
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
                        // controller: postController,
                        decoration: const InputDecoration(
                          hintText: "Cari pesan",
                          border: InputBorder.none,

                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: ColorApp.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return Container(
                    padding: EdgeInsets.all(SizeApp.h16),
                    child: Text(
                      "Message from post id",
                      style: TypographyApp.label,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppbarMessagesPage extends StatelessWidget {
  const AppbarMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeApp.w16,
        vertical: SizeApp.h12,
      ),
      child: Row(children: [Text("Messages", style: TypographyApp.headline1)]),
    );
  }
}
