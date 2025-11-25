import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/request_verified_page_controller.dart';

class RequestVerifiedPageView extends GetView<RequestVerifiedPageController> {
  const RequestVerifiedPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RequestVerifiedPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RequestVerifiedPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
