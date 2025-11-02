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

  // void dataUser(User userFirebase) async {
  //   await _firestore.collection('users').doc(userFirebase.uid).get().then((
  //     value,
  //   ) {
  //     print(value.exists);
  //     user.name = value['name'];
  //     user.cost = value['cost'];
  //   });
  //   user.email = userFirebase.email!;
  //   user.uid = userFirebase.uid;
  // }
}
