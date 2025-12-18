import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';
import 'package:xnusa_mobile/app/modules/home/controllers/like_controller.dart';
import 'package:xnusa_mobile/app/modules/reply_post_page/controllers/reply_post_page_controller.dart';
import 'package:xnusa_mobile/app/modules/home/services/ingestion.dart';

class HomeController extends GetxController {
  final supabase = Supabase.instance.client;
  final ingestion = Ingestion();

  // Observable list of posts
  var profileData = {}.obs;
  var posts = <PostModel>[].obs;
  var isLoading = false.obs;
  final likeC = Get.put(LikeController());
  final repliesC = Get.put(
    ReplyPostPageController(),
  ); // 🔥 inject 1x, bisa reuse global

  // ✅ cukup panggil service global
  Future<void> toggleLike(PostModel post) async {
    await likeC.toggleLikeOptimistic(postList: posts, post: post);
  }

  /// ✅ Fetch all posts (with user profiles)
  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;
      final response = await supabase
          .from('posts')
          .select('''
      *,
      profiles(username, profile_image_url),
      likes(user_id)
    ''')
          .order('created_at', ascending: false);

      posts.value =
          (response as List)
              .map(
                (post) => PostModel.fromJson({
                  ...post,
                  'is_liked': (post['likes'] as List).any(
                    (like) => like['user_id'] == user!.id,
                  ), // ✅ check apakah user sudah like
                }),
              )
              .toList();
    } catch (e) {
      print('⚠️ Error fetchPosts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> getReplies(int postId) async {
    final data = await supabase
        .from('replies')
        .select()
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    return data;
  }

  /// ✅ Add a new post
  Future<void> addPost(String description, {String? imageUrl}) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase.from('posts').insert({
        'user_id': user.id,
        'description': description,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
        'like_count': 0,
        'comment_count': 0,
      });

      // Ingestion Start
      try {
        final resp = await ingestion.ingest(
          description: description,
          metadata: {'uploaderId': user.id, 'source': 'Thread'},
        );

        if (!resp.allowed) {
          Get.snackbar(
            'Ingestion Not Allowed',
            resp.reason ?? 'Blocked by moderation.',
          );
        } else {
          Get.snackbar('Ingestion Succeed', 'Post has been ingested.');
        }
      } catch (e) {
        print('⚠️ Error Ingestion: $e');
      }
      // Ingestion End

      await fetchPosts();
    } catch (e) {
      print('⚠️ Error addPost: $e');
    }
  }

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
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchPosts();
  }
}
