import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/explore_page/views/explore_page_view.dart';
import 'package:xnusa_mobile/app/modules/home/views/home_view.dart';
import 'package:xnusa_mobile/app/modules/message_page/views/message_page_view.dart';
import 'package:xnusa_mobile/app/modules/profile_page/views/profile_page_view.dart';
import 'package:xnusa_mobile/app/modules/search_page/views/search_page_view.dart';
import 'package:xnusa_mobile/constant/constant.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.put(
      DashboardController(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => IndexedStack(
          index: dashboardController.selectedIndex.value,
          children: const [
            HomeView(),
            SearchPageView(),
            ExplorePageView(),
            MessagePageView(),
            ProfilePageView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => SizedBox(
          height: 90,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            Icons.home_outlined,
                            Icons.home,
                            "Home",
                            0,
                            dashboardController,
                          ),
                          _buildNavItem(
                            Icons.search,
                            Icons.search,
                            "Search",
                            1,
                            dashboardController,
                          ),
                          const SizedBox(width: 60), // Space for center item
                          _buildNavItem(
                            Icons.history_outlined,
                            Icons.history,
                            "History",
                            3,
                            dashboardController,
                          ),
                          _buildNavItem(
                            Icons.person_outline,
                            Icons.person,
                            "Profile",
                            4,
                            dashboardController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Center floating button
              Positioned(
                top: 0,
                left: MediaQuery.of(context).size.width / 2 - 35,
                child: _buildCenterNavItem(dashboardController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    int index,
    DashboardController controller,
  ) {
    final isSelected = controller.selectedIndex.value == index;

    return InkWell(
      onTap: () => controller.changeIndex(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              size: 26,
              color: isSelected ? Colors.black : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterNavItem(DashboardController controller) {
    return InkWell(
      onTap: () => controller.changeIndex(2),
      borderRadius: BorderRadius.circular(35),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorApp.primary,
              boxShadow: [
                BoxShadow(
                  color: ColorApp.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.map_outlined, size: 32, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
