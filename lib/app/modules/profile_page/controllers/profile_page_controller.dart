import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';
import 'package:xnusa_mobile/app/modules/home/controllers/like_controller.dart';

class ProfilePageController extends GetxController {
  final supabase = Supabase.instance.client;
  var profileData = {}.obs;
  var userPosts = <PostModel>[].obs; // post milik user login
  var userLikes = <PostModel>[].obs; // post yang dilike user
  var isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  final likeC = Get.put(LikeController()); // 🔥 controller global

  /// ✅ Toggle like menggunakan mekanisme optimistic update
  Future<void> toggleLike(PostModel post, RxList<PostModel> list) async {
    await likeC.toggleLikeOptimistic(postList: list, post: post);
  }

  Future<void> pickAndUploadProfileImage() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // 1️⃣ Pilih gambar
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      final fileExt = picked.name.split('.').last;
      final filePath = 'profile/${user.id}.$fileExt';

      // 2️⃣ Upload ke Supabase Storage
      await supabase.storage
          .from('profile_images')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      // 3️⃣ Dapatkan URL public
      final imageUrl = supabase.storage
          .from('profile_images')
          .getPublicUrl(filePath);

      // 4️⃣ Update ke tabel profiles
      await supabase
          .from('profiles')
          .update({'profile_image_url': imageUrl})
          .eq('id', user.id);

      // 5️⃣ Refresh data profile
      await fetchProfile();

      Get.snackbar("Success", "Foto profil berhasil diperbarui");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// 🔹 Ambil data profil + konten user
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final res =
          await supabase
              .from('profiles')
              .select()
              .eq('id', user.id)
              .maybeSingle();

      if (res != null) profileData.value = res;

      await fetchPostUser();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Ambil semua post milik user login dan semua post yang dia like
  Future<void> fetchPostUser() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // ✅ Ambil semua post user login + status like-nya
      final postsResponse = await supabase
          .from('posts')
          .select('''
          *,
          profiles(username, profile_image_url),
          likes(user_id)
        ''')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      // Mapping hasilnya menjadi list PostModel
      userPosts.value =
          (postsResponse as List)
              .map(
                (post) => PostModel.fromJson({
                  ...post,
                  'is_liked': (post['likes'] as List).any(
                    (like) => like['user_id'] == user.id,
                  ), // 🔥 cek apakah user like post sendiri
                }),
              )
              .toList();

      // ✅ Ambil semua post yang pernah di-like oleh user login
      final likeResponse = await supabase
          .from('likes')
          .select('''
      id,
      created_at,
      posts (
        id,
        description,
        image_url,
        created_at,
        like_count,
        comment_count,
        profiles (
          username,
          display_name,
          profile_image_url
        ),
        likes(user_id)
      )
    ''')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      // ✅ Ubah hasilnya jadi PostModel dengan flag isLiked
      userLikes.value =
          (likeResponse as List)
              .map(
                (like) => PostModel.fromJson({
                  ...like['posts'],
                  'is_liked': (like['posts']['likes'] as List).any(
                    (l) => l['user_id'] == user.id,
                  ),
                }),
              )
              .toList();
    } catch (e) {
      print("❌ Error fetchPostUser: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Upload foto profil baru ke Supabase Storage
  Future<void> uploadProfileImage() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final file = File(picked.path);
      final fileName = 'profile_${user.id}.jpg';

      // Upload ke storage Supabase
      await supabase.storage
          .from('profile_images')
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      // Ambil URL publik
      final imageUrl = supabase.storage
          .from('profile_images')
          .getPublicUrl(fileName);

      // Update ke tabel profiles
      await supabase
          .from('profiles')
          .update({'profile_image_url': imageUrl})
          .eq('id', user.id);

      await fetchProfile();
      Get.snackbar('Berhasil', 'Foto profil diperbarui');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadAllContent();
  }

  /// Jalankan semua fetch secara berurutan
  Future<void> loadAllContent() async {
    await fetchProfile();
    await fetchPostUser();
  }
}
