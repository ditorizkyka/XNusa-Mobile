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
  // SIGN IN WITH X (TWITTER)
  // ---------------------------------------------
  Future<void> signInWithX() async {
    try {
      isLoading.value = true;

      // 🔹 1. Trigger Supabase X OAuth
      await supabase.auth.signInWithOAuth(
        OAuthProvider.twitter,
        redirectTo: 'io.supabase.flutter://login-callback',
      );

      // 🔹 2. Dengarkan perubahan Auth state
      supabase.auth.onAuthStateChange.listen((data) async {
        final session = data.session;
        final userData = session?.user;

        print(userData?.userMetadata);

        if (userData != null) {
          // Ambil metadata X (nama field bisa bervariasi antar provider)
          final meta = userData.userMetadata ?? {};

          // Fallback username (karena email bisa null di X)
          final usernameFromMeta =
              (meta['preferred_username'] ??
                      meta['user_name'] ??
                      meta['username'] ??
                      meta['screen_name'])
                  ?.toString();

          final displayNameFromMeta =
              (meta['full_name'] ?? meta['name'])?.toString();

          final avatarFromMeta =
              (meta['avatar_url'] ??
                      meta['picture'] ??
                      meta['profile_image_url'])
                  ?.toString();

          // Kalau ada email, boleh dipakai jadi username default
          final usernameFallback =
              userData.email != null
                  ? userData.email!.split('@')[0]
                  : 'user_${userData.id.substring(0, 8)}';

          final usernameFinal =
              (usernameFromMeta?.isNotEmpty ?? false)
                  ? usernameFromMeta!
                  : usernameFallback;

          final displayNameFinal =
              (displayNameFromMeta?.isNotEmpty ?? false)
                  ? displayNameFromMeta!
                  : usernameFinal;

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
              'username': usernameFinal,
              'display_name': displayNameFinal,
              'bio': '',
              'profile_image_url': avatarFromMeta,
            });
          }

          // 🔹 5. Simpan status login ke Hive
          final box = await Hive.openBox('userBox');
          await box.put('isLoggedIn', true);

          // 🔹 6. Notifikasi
          Get.snackbar('Success', 'Login with X berhasil!');

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

  // ---------------------------------------------
  // SIGN IN WITH MICROSOFT (AZURE / ENTRA ID)
  // ---------------------------------------------
  Future<void> signInWithMicrosoft() async {
    try {
      isLoading.value = true;

      // 1) Trigger Supabase Microsoft OAuth
      await supabase.auth.signInWithOAuth(
        OAuthProvider.azure, // Microsoft provider
        redirectTo: 'io.supabase.flutter://login-callback',
        scopes: 'email',
      );

      // 2) Listen perubahan auth state (HATI-HATI: bisa double trigger kalau dipanggil berkali-kali)
      supabase.auth.onAuthStateChange.listen((data) async {
        final session = data.session;
        final userData = session?.user;
        if (userData == null) return;

        final meta = userData.userMetadata ?? {};

        // Azure biasanya kasih email, tapi tetap bikin fallback aman
        final email = userData.email;
        final displayName =
            (meta['full_name'] ??
                    meta['name'] ??
                    meta['displayName'] ??
                    'No Name')
                .toString();

        // Avatar kadang tidak ada di Microsoft Graph default
        final avatarUrl = (meta['avatar_url'] ?? meta['picture'])?.toString();

        final username =
            email != null
                ? email.split('@')[0]
                : 'user_${userData.id.substring(0, 8)}';

        // 3) Cek profile existing
        final existingProfile =
            await supabase
                .from('profiles')
                .select()
                .eq('id', userData.id)
                .maybeSingle();

        // 4) Insert profile kalau belum ada
        if (existingProfile == null) {
          await supabase.from('profiles').upsert({
            'id': userData.id,
            'username': username,
            'display_name': displayName,
            'bio': '',
            'profile_image_url': avatarUrl,
          });
        }

        // 5) Simpan status login ke Hive
        final box = await Hive.openBox('userBox');
        await box.put('isLoggedIn', true);

        // 6) Notifikasi
        Get.snackbar('Success', 'Login with Microsoft berhasil!');

        // 7) Navigate
        Get.offAllNamed('/dashboard');
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
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
