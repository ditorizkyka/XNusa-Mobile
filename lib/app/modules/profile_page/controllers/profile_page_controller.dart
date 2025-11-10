import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';

class ProfilePageController extends GetxController {
  final supabase = Supabase.instance.client;
  var profileData = {}.obs;
  var userPosts = <PostModel>[].obs; // post milik user login
  var userReplies = <PostModel>[].obs;
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

  Future<void> fetchPostUser() async {
    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // Fetch semua post milik user login
      final postsResponse = await supabase
          .from('posts')
          .select('*, profiles(username, profile_image_url)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      userPosts.value =
          (postsResponse as List).map((p) => PostModel.fromJson(p)).toList();

      print("DISINI USER POSTS: ${userPosts.length}");

      // Fetch semua replies milik user login
      final repliesResponse = await supabase
          .from('replies')
          .select(
            '*, profiles(username, profile_image_url), posts(description)',
          )
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      userReplies.value =
          (repliesResponse as List).map((r) => PostModel.fromJson(r)).toList();
    } catch (e) {
      print("Error fetchUserContent: $e");
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

  // Jalankan saat inisialisasi controller
  @override
  void onInit() {
    super.onInit();
    loadAllContent();
  }

  // Fungsi gabungan agar urutannya jelas
  Future<void> loadAllContent() async {
    await fetchProfile();
    await fetchPostUser();
  }
}
