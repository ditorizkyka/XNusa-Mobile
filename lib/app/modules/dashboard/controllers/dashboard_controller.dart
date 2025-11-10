import 'package:get/get.dart';
import 'package:xnusa_mobile/app/data/models/userModel.dart';

class DashboardController extends GetxController {
  RxInt selectedIndex = 0.obs;

  UserModel user = UserModel(
    uid: '',
    displayName: '',
    email: '',
    isLoggedIn: false,
  );

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  // Fetch profiles user + post users + replies users

  // void dataUser(User userFirebase) async {}
}
