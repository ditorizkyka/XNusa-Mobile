import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';
import 'package:xnusa_mobile/app/data/models/reply_model.dart';
import 'package:xnusa_mobile/app/modules/home/controllers/like_controller.dart';

class ReplyPostPageController extends GetxController {
  final supabase = Supabase.instance.client;
  final replyController = TextEditingController();
  final isLoading = false.obs;
  RxInt charCount = 0.obs;
  final replies = <ReplyModel>[].obs;

  // ✅ Tambahkan observable untuk post yang sedang dilihat
  final currentPost = PostModel().obs;

  // ✅ Tambahkan LikeController
  final likeC = Get.find<LikeController>();

  // ✅ Daftar sementara untuk optimistic update (single post)
  final RxList<PostModel> _singlePostList = <PostModel>[].obs;

  final count = 0.obs;

  @override
  void onInit() {
    replyController.addListener(() {
      charCount.value = replyController.text.length;
    });

    // ✅ Set initial post dari arguments
    if (Get.arguments != null && Get.arguments is PostModel) {
      currentPost.value = Get.arguments;
      _singlePostList.add(currentPost.value);
    }

    super.onInit();
  }

  // ✅ Method untuk toggle like pada post yang sedang dibuka
  Future<void> togglePostLike() async {
    if (currentPost.value.id == null) return;

    // Gunakan list sementara untuk optimistic update
    await likeC.toggleLikeOptimistic(
      postList: _singlePostList,
      post: currentPost.value,
    );

    // Update currentPost dengan nilai terbaru dari list
    if (_singlePostList.isNotEmpty) {
      currentPost.value = _singlePostList.first;
    }
  }

  Future<void> submitReply({required int postId}) async {
    final replyText = replyController.text.trim();
    final user = supabase.auth.currentUser;
    if (user == null) return;

    // insert reply
    await supabase.from('replies').insert({
      'post_id': postId,
      'user_id': user.id,
      'content': replyText,
      'created_at': DateTime.now().toIso8601String(),
    });

    // update comment_count
    await supabase.rpc('increment_comment_count', params: {'post_id': postId});

    Get.snackbar("Success", "Reply submitted successfully");
    replyController.clear();
    await fetchReplies(postId);

    // ✅ Update comment count di currentPost
    currentPost.value = currentPost.value.copyWith(
      commentCount: (currentPost.value.commentCount) + 1,
    );
  }

  Future<void> fetchReplies(int postId) async {
    try {
      isLoading.value = true;
      final response = await supabase
          .from('replies')
          .select('*, profiles(username, profile_image_url)')
          .eq('post_id', postId)
          .order('created_at', ascending: false);

      replies.value =
          (response as List)
              .map((json) => ReplyModel.fromJson(json as Map<String, dynamic>))
              .toList();
    } catch (e) {
      print('⚠️ Error fetchReplies: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    replyController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
