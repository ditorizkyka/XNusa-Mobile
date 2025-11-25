import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import '../controllers/explore_page_controller.dart';

class ExplorePageView extends GetView<ExplorePageController> {
  const ExplorePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ARView(onARViewCreated: controller.onARViewCreated),

          // // Tombol interaksi (bubble chat)
          // Obx(() {
          //   return controller.showBubbleButton.value
          //       ? Positioned(
          //         bottom: 24,
          //         right: 24,
          //         child: FloatingActionButton(
          //           onPressed: () {
          //             // Nanti akan memunculkan gambar / bubble chat UI
          //           },
          //           child: const Icon(Icons.chat),
          //         ),
          //       )
          //       : const SizedBox.shrink();
          // }),
        ],
      ),
    );
  }
}
