import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import '../controllers/explore_page_controller.dart';

class ExplorePageView extends GetView<ExplorePageController> {
  const ExplorePageView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<ExplorePageController>(() => ExplorePageController());
    return Scaffold(
      backgroundColor: ColorApp.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeApp.w16,
                vertical: SizeApp.h12,
              ),
              child: Row(
                children: [
                  Text("Explore Nusa", style: TypographyApp.headline1),
                ],
              ),
            ),

            // IMPORTANT: kasih tinggi untuk map
            Expanded(
              child: Obx(() {
                return Stack(
                  children: [
                    FlutterMap(
                      mapController: controller.mapController,
                      options: const MapOptions(
                        initialCenter: ExplorePageController.centerIndonesia,
                        initialZoom: 5,
                        minZoom: 4,
                        maxZoom: 18,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c', 'd'],
                          userAgentPackageName: 'com.arkit.arkit_try',
                          maxZoom: 19,
                        ),
                        MarkerLayer(markers: controller.buildMarkers()),
                      ],
                    ),

                    // Attribution
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        color: Colors.white.withOpacity(0.7),
                        child: const Text(
                          '© CartoDB, © OpenStreetMap contributors',
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    // Info panel reactive
                    Obx(() {
                      if (controller.selectedIsland.value.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Card(
                          color: ColorApp.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.place,
                                    color: Colors.blue[700],
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Terpilih',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        controller.selectedIsland.value,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: controller.clearSelected,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // Floating Buttons
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton(
                            heroTag: 'legend',
                            mini: true,
                            onPressed: controller.showLegend,
                            backgroundColor: ColorApp.lightGrey,
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.blue[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          FloatingActionButton(
                            heroTag: 'reset',
                            mini: true,
                            onPressed: controller.resetCamera,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.refresh, color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ),

                    // Loading
                    if (controller.isLoading.value)
                      const Positioned(
                        top: 10,
                        right: 10,
                        child: SafeArea(
                          child: Card(
                            color: ColorApp.white,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  // Text(
                                  //   "Memuat data baru...",
                                  //   style: TextStyle(fontSize: 10),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
