import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;
  var isLoading = false.obs;

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    try {
      isLoading.value = true;

      final res = await supabase.auth.signUp(email: email, password: password);

      final user = res.user;
      if (user != null) {
        // Buat data profil di tabel profiles
        await supabase.from('profiles').insert({
          'id': user.id,
          'username': username,
          'display_name': displayName,
          'bio': '',
          'profile_image_url': null,
        });

        Get.snackbar('Sukses', 'Akun berhasil dibuat!');
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading(true);
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    Get.offAllNamed('/login');
  }

  // final count = 0.obs;
  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  // void increment() => count.value++;
}
