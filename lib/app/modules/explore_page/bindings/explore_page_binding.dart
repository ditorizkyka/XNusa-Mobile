import 'package:get/get.dart';
import '../controllers/explore_page_controller.dart';

class ExplorePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExplorePageController>(() => ExplorePageController());
  }
}
