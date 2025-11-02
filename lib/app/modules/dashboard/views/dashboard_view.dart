import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/explore_page/views/explore_page_view.dart';
import 'package:xnusa_mobile/app/modules/home/views/home_view.dart';
import 'package:xnusa_mobile/app/modules/profile_page/views/profile_page_view.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.put(
      DashboardController(),
    );
    // dashboardController.detailCostInit();
    return Scaffold(
      // backgroundColor: ColorAp.primaryGrey,
      body: Obx(
        () => IndexedStack(
          index: dashboardController.selectedIndex.value,
          children: const [
            HomeView(),
            ProfilePageView(),
            ExplorePageView(),
            // ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // Menghilangkan efek splash
          highlightColor: Colors.transparent, // Menghilangkan efek highlight
        ),
        child: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            currentIndex: dashboardController.selectedIndex.value,
            onTap: (index) => dashboardController.changeIndex(index),
            selectedItemColor: Colors.amber, // Warna saat dipilih
            unselectedItemColor: Colors.white60, // Warna saat tidak dipilih
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            items: [
              _buildNavItem(
                Icons.home_outlined,
                Icons.home,
                "Home",
                0,
                dashboardController,
              ),
              _buildNavItem(
                Icons.query_stats_outlined,
                Icons.query_stats,
                "Explore",
                1,
                dashboardController,
              ),
              _buildNavItem(
                Icons.add_circle_outline,
                Icons.add_circle,
                "Profile",
                2,
                dashboardController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    int index,
    DashboardController controller,
  ) {
    return BottomNavigationBarItem(
      icon: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              controller.selectedIndex.value == index
                  ? filledIcon
                  : outlinedIcon,
              size: 30,
              color:
                  controller.selectedIndex.value == index
                      ? Colors
                          .amber // Warna saat dipilih
                      : Colors.grey, // Warna saat tidak dipilih
            ),
            // Gap.h4, // Jarak antara icon & label
            Text(
              label,
              style: TextStyle(
                fontSize: 12,

                color:
                    controller.selectedIndex.value == index
                        ? Colors
                            .amber // Warna saat dipilih
                        : Colors.grey, // Warna saat tidak dipilih
              ),
            ),
            // Gap.h8
          ],
        ),
      ),
      label: "",
    );
  }
}
