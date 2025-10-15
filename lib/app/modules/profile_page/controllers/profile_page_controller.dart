import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePageController extends GetxController {
  final supabase = Supabase.instance.client;
  var profileData = {}.obs;
  var isLoading = false.obs;

  // Ambil data profil user dari Supabase
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final res =
          await supabase.from('profiles').select().eq('id', user.id).single();

      profileData.value = res;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Upload foto profil baru ke Supabase Storage
  Future<void> uploadProfileImage() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final file = File(picked.path);
      final fileName = 'profile_${user.id}.jpg';

      // Upload ke storage "profile_images"
      await supabase.storage
          .from('profile_images')
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      // Dapatkan URL publik
      final imageUrl = supabase.storage
          .from('profile_images')
          .getPublicUrl(fileName);

      // Update di tabel profiles
      await supabase
          .from('profiles')
          .update({'profile_image_url': imageUrl})
          .eq('id', user.id);

      // Refresh data profil
      await fetchProfile();

      Get.snackbar('Berhasil', 'Foto profil diperbarui');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }
}
