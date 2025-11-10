import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';

class HomeController extends GetxController {
  final supabase = Supabase.instance.client;

  var posts = <PostModel>[].obs;
  var isLoading = false.obs;

  // Ambil semua post + join ke profiles

  Future<void> toggleLike(int postId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      // Cek apakah user sudah like post ini
      final existingLike =
          await supabase
              .from('likes')
              .select()
              .eq('user_id', user.id)
              .eq('post_id', postId)
              .maybeSingle();

      if (existingLike == null) {
        // Jika belum like → insert
        await supabase.from('likes').insert({
          'user_id': user.id,
          'post_id': postId,
          'created_at': DateTime.now().toIso8601String(),
        });
      } else {
        // Jika sudah like → delete (unlike)
        await supabase
            .from('likes')
            .delete()
            .eq('user_id', user.id)
            .eq('post_id', postId);
      }

      // Refresh daftar post
      await fetchPosts();
    } catch (e) {
      print("Error toggleLike: $e");
    }
  }

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;

      final response = await supabase
          .from('posts')
          .select('*, profiles(username, profile_image_url)')
          .order('created_at', ascending: false);

      posts.value =
          (response as List).map((post) => PostModel.fromJson(post)).toList();
    } catch (e) {
      print("Error fetchPosts: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Tambah post baru
  Future<void> addPost(String description) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase.from('posts').insert({
        'user_id': user.id,
        'description': description,
        'created_at': DateTime.now().toIso8601String(),
        'like_count': 0,
        'comment_count': 0,
      });

      // Refresh timeline
      await fetchPosts();
    } catch (e) {
      print("Error addPost: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }
}
