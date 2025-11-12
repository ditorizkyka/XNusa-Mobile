import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xnusa_mobile/constant/constant.dart';

import '../controllers/search_page_controller.dart';

class SearchPageView extends GetView<SearchPageController> {
  const SearchPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(children: [AppbarSearchPage()])),
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
