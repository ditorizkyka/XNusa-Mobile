import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/signin_page.dart';
import '../modules/auth/views/signup_page.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/edit_profile_page/bindings/edit_profile_page_binding.dart';
import '../modules/edit_profile_page/views/edit_profile_page_view.dart';
import '../modules/explore_page/bindings/explore_page_binding.dart';
import '../modules/explore_page/views/explore_page_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/message_page/bindings/message_page_binding.dart';
import '../modules/message_page/views/message_page_view.dart';
import '../modules/profile_page/bindings/profile_page_binding.dart';
import '../modules/profile_page/views/profile_page_view.dart';
import '../modules/reply_post_page/bindings/reply_post_page_binding.dart';
import '../modules/reply_post_page/views/reply_post_page_view.dart';
import '../modules/request_verified_page/bindings/request_verified_page_binding.dart';
import '../modules/request_verified_page/views/request_verified_page_view.dart';
import '../modules/search_page/bindings/search_page_binding.dart';
import '../modules/search_page/views/search_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SIGNIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => SigninPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_PAGE,
      page: () => const ProfilePageView(),
      binding: ProfilePageBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE_PAGE,
      page: () => const ExplorePageView(),
      binding: ExplorePageBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_PAGE,
      page: () => const SearchPageView(),
      binding: SearchPageBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGE_PAGE,
      page: () => const MessagePageView(),
      binding: MessagePageBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE_PAGE,
      page: () => const EditProfilePageView(),
      binding: EditProfilePageBinding(),
    ),
    GetPage(
      name: _Paths.REQUEST_VERIFIED_PAGE,
      page: () => const RequestVerifiedPageView(),
      binding: RequestVerifiedPageBinding(),
    ),
    GetPage(
      name: _Paths.REPLY_POST_PAGE,
      page: () => const ReplyPostPageView(),
      binding: ReplyPostPageBinding(),
    ),
  ];
}
