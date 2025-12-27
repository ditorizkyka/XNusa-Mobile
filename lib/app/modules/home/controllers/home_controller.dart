import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';
import 'package:xnusa_mobile/app/modules/home/controllers/like_controller.dart';
import 'package:xnusa_mobile/app/modules/home/services/ingestion.dart';

class HomeController extends GetxController {
  final supabase = Supabase.instance.client;
  final ingestion = Ingestion();

  // Observable list of posts
  var profileData = {}.obs;
  var posts = <PostModel>[].obs;
  var isLoading = false.obs;
  final likeC = Get.put(LikeController());
  // 🔥 inject 1x, bisa reuse global

  // ✅ cukup panggil service global
  Future<void> toggleLike(PostModel post) async {
    await likeC.toggleLikeOptimistic(postList: posts, post: post);
  }

  /// ✅ Add a new post
  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;

      // ✅ 1) fetch posts + counts
      final postsResp = await supabase
          .from('posts')
          .select('''
      *,
      profiles(username, display_name, profile_image_url, isVerified),
      likes(user_id),
      likes_count:likes(count),
      replies_count:replies(count)
    ''')
          .order('created_at', ascending: false);

      final rawPosts = (postsResp as List).cast<Map<String, dynamic>>();

      // ambil semua postId untuk query preview replies
      final postIds =
          rawPosts
              .map((p) => p['id'])
              .where((id) => id != null)
              .cast<int>()
              .toList();

      // ✅ 2) fetch replies terbaru untuk semua postId (sekali query)
      // NOTE: kita ambil banyak dulu lalu di-group per post dan ambil 2 teratas.
      // Batasi hasil biar tidak kebanyakan: misalnya 200
      Map<int, List<String>> avatarByPostId = {};

      if (postIds.isNotEmpty) {
        final repliesResp = await supabase
            .from('replies')
            .select(
              'post_id, created_at, profiles(profile_image_url, display_name)',
            )
            .inFilter('post_id', postIds)
            .order('created_at', ascending: false)
            .limit(200); // ✅ batas aman, bisa kamu naikkan sesuai kebutuhan

        final rawReplies = (repliesResp as List).cast<Map<String, dynamic>>();

        for (final r in rawReplies) {
          final postId = r['post_id'] as int?;
          if (postId == null) continue;

          avatarByPostId.putIfAbsent(postId, () => []);

          // stop kalau sudah punya 2 avatar preview
          if (avatarByPostId[postId]!.length >= 2) continue;

          final p = (r['profiles'] ?? {}) as Map;
          final url = p['profile_image_url'] as String?;
          final name = (p['display_name'] as String?) ?? 'User';

          final avatar =
              url ??
              'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}';

          // optional: hindari duplikat avatar (kalau user yang sama reply berkali-kali)
          if (!avatarByPostId[postId]!.contains(avatar)) {
            avatarByPostId[postId]!.add(avatar);
          }
        }
      }

      // ✅ map ke PostModel
      posts.value =
          rawPosts.map((post) {
            final likesCountList = post['likes_count'] as List?;
            final likesCount =
                (likesCountList != null && likesCountList.isNotEmpty)
                    ? (likesCountList[0]['count'] as int? ?? 0)
                    : 0;

            final repliesCountList = post['replies_count'] as List?;
            final repliesCount =
                (repliesCountList != null && repliesCountList.isNotEmpty)
                    ? (repliesCountList[0]['count'] as int? ?? 0)
                    : 0;

            final isLiked = (post['likes'] as List).any(
              (like) => like['user_id'] == user?.id,
            );

            final postId = post['id'] as int?;
            final avatars =
                postId != null ? (avatarByPostId[postId] ?? []) : <String>[];

            return PostModel.fromJson({
              ...post,
              'like_count': likesCount,
              'comment_count': repliesCount,
              'is_liked': isLiked,
              'reply_avatar_urls': avatars, // ✅ kita kirim ke model
            });
          }).toList();
    } catch (e) {
      print('⚠️ Error fetchPosts: $e');
    } finally {
      isLoading.value = false;
    }
  }

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
          metadata: {'user_id': user.id, 'source': 'post'},
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

  Future<void> reportPost(int postId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      Get.snackbar("Gagal", "Kamu harus login dulu");
      return;
    }

    try {
      await supabase.from('post_reports').insert({
        'reporter_id': user.id,
        'post_id': postId,
        // created_at otomatis oleh DB
      });

      Get.snackbar("Berhasil", "Post berhasil dilaporkan");
    } on PostgrestException catch (e) {
      // ✅ jika user sudah pernah report (kena unique index)
      if (e.code == '23505') {
        Get.snackbar("Info", "Kamu sudah melaporkan post ini");
        return;
      }
      Get.snackbar("Error", e.message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchPosts();
  }
}
