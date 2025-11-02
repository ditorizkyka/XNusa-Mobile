import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/explore_page_controller.dart';

class ExplorePageView extends GetView<ExplorePageController> {
  const ExplorePageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExplorePageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ExplorePageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
