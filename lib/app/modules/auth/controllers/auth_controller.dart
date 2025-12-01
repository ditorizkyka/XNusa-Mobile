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
        Get.offAllNamed('/signin');
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
  }

  // ---------------------------------------------
  // SIGN IN WITH GOOGLE
  // ---------------------------------------------
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // 🔹 1. Trigger Supabase Google OAuth
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback',
      );

      // 🔹 2. Dengarkan perubahan Auth state
      supabase.auth.onAuthStateChange.listen((data) async {
        final session = data.session;
        final userData = session?.user;

        if (userData != null) {
          // 🔹 3. Cek apakah profile sudah dibuat di tabel 'profiles'
          final existingProfile =
              await supabase
                  .from('profiles')
                  .select()
                  .eq('id', userData.id)
                  .maybeSingle();

          if (existingProfile == null) {
            // 🔹 4. Buat profile baru untuk user baru
            await supabase.from('profiles').upsert({
              'id': userData.id,
              'username': userData.email?.split('@')[0],
              'display_name': userData.userMetadata?['full_name'] ?? 'No Name',
              'bio': '',
              'profile_image_url': userData.userMetadata?['avatar_url'],
            });
          }

          // 🔹 5. Simpan status login ke Hive
          final box = await Hive.openBox('userBox');
          await box.put('isLoggedIn', true);

          // 🔹 6. Notifikasi
          Get.snackbar('Success', 'Login with Google berhasil!');

          // 🔹 7. Navigate
          Get.offAllNamed('/dashboard');
        }
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
