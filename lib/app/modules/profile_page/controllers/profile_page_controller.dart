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
  var followers =
      <Map<String, dynamic>>[].obs; // daftar followers + data profil
  var followersCount = 0.obs;

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
              .select(
                'id, username, display_name, bio, profile_image_url, isVerified',
              )
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

  Future<void> fetchPostUser() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // ✅ Threads: post milik user + is_liked + REAL count likes
      final postsResponse = await supabase
          .from('posts')
          .select('''
          *,
          profiles(username, profile_image_url, display_name),
          likes(user_id),
          likes_count:likes(count)
        ''')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      userPosts.value =
          (postsResponse as List).map((post) {
            final likesCountList = post['likes_count'] as List?;
            final likesCount =
                (likesCountList != null && likesCountList.isNotEmpty)
                    ? (likesCountList[0]['count'] as int? ?? 0)
                    : 0;

            final isLiked = (post['likes'] as List).any(
              (l) => l['user_id'] == user.id,
            );

            return PostModel.fromJson({
              ...post,
              'like_count': likesCount, // ✅ override dari hasil COUNT
              'is_liked': isLiked,
            });
          }).toList();

      // ✅ Likes tab: post yang di-like user + REAL count likes
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
            comment_count,
            profiles (
              username,
              display_name,
              profile_image_url
            ),
            likes(user_id),
            likes_count:likes(count)
          )
        ''')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      userLikes.value =
          (likeResponse as List).map((likeRow) {
            final post = likeRow['posts'] as Map<String, dynamic>;

            final likesCountList = post['likes_count'] as List?;
            final likesCount =
                (likesCountList != null && likesCountList.isNotEmpty)
                    ? (likesCountList[0]['count'] as int? ?? 0)
                    : 0;

            final isLiked = (post['likes'] as List).any(
              (l) => l['user_id'] == user.id,
            );

            return PostModel.fromJson({
              ...post,
              'like_count': likesCount, // ✅ override dari hasil COUNT
              'is_liked': isLiked,
            });
          }).toList();
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

  Future<void> fetchFollowers() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // Ambil semua yang follow user ini (following_id = user.id)
      final res = await supabase
          .from('follows')
          .select('''
          follower_id,
          created_at,
          profiles:profiles!follows_follower_id_fkey(
            id,
            username,
            display_name,
            profile_image_url,
            isVerified
          )
        ''')
          .eq('following_id', user.id)
          .order('created_at', ascending: false);

      final list = (res as List);

      // Simpan list follower (profilnya ada di key: 'profiles')
      followers.value =
          list.map((row) {
            final profile = row['profiles'] as Map<String, dynamic>?;
            return {
              'follower_id': row['follower_id'],
              'created_at': row['created_at'],
              'profile': profile, // berisi id, username, display_name, dll
            };
          }).toList();

      followersCount.value = followers.length;
    } catch (e) {
      print("❌ Error fetchFollowers: $e");
      Get.snackbar("Error", e.toString());
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
    await fetchFollowers();
  }
}
