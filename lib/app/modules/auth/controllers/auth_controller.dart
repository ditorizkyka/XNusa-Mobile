import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:xnusa_mobile/app/data/models/userModel.dart';
import 'package:xnusa_mobile/shared/constanta.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;
  var isLoading = false.obs;
  var user = Rxn<UserModel>();

  @override
  /// 🔹 SIGN UP
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
        // ✅ Simpan data profil ke tabel 'profiles'
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

  /// 🔹 SIGN IN
  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      // final box = await Hive.openBox('userBox');
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final userData = response.user;

      if (userData != null) {
        // kalau kamu punya tabel profiles, bisa fetch nama di sini
        final profileRes =
            await supabase
                .from('profiles')
                .select('display_name')
                .eq('id', userData.id)
                .maybeSingle();

        final userModel = UserModel(
          uid: userData.id,
          email: userData.email ?? '',
          displayName: profileRes?['display_name'] ?? '',
          isLoggedIn: true,
        );

        print("SUKSES LOGIN: ${userModel.email}");
        final box = await Hive.openBox('userBox');
        await box.put('isLoggedIn', true);

        Get.snackbar('Sukses', 'Login berhasil!');
        Get.offAllNamed('/dashboard');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 LOGOUT
  Future<void> signOut() async {
    await supabase.auth.signOut();
    await box.clear();
    user.value = null;
    Get.offAllNamed('/signin');
  }
}
