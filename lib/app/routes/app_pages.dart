import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/auth/views/signin_page.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/signup_page.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

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
  ];
}
