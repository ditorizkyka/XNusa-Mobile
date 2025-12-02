import 'package:get/get.dart';

import '../controllers/request_verified_page_controller.dart';

class RequestVerifiedPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestVerifiedPageController>(
      () => RequestVerifiedPageController(),
    );
  }
}
