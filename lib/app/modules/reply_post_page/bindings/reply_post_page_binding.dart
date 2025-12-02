import 'package:get/get.dart';

import '../controllers/reply_post_page_controller.dart';

class ReplyPostPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReplyPostPageController>(
      () => ReplyPostPageController(),
    );
  }
}
