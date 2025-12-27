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

  // ✅ Observable untuk validasi
  final isReplyValid = false.obs;
  final isSubmitting = false.obs;

  // ✅ Tambahkan observable untuk post yang sedang dilihat
  final currentPost = PostModel().obs;

  // ✅ Tambahkan LikeController
  final likeC = Get.find<LikeController>();

  // ✅ Daftar sementara untuk optimistic update (single post)
  final RxList<PostModel> _singlePostList = <PostModel>[].obs;

  final count = 0.obs;

  // ✅ Rules untuk reply (mirip X/Twitter)
  static const int minReplyLength = 1;
  static const int maxReplyLength = 280; // X limit is 280 characters

  @override
  void onInit() {
    replyController.addListener(_validateReply);

    // ✅ Set initial post dari arguments
    if (Get.arguments != null && Get.arguments is PostModel) {
      currentPost.value = Get.arguments;
      _singlePostList.add(currentPost.value);
    }
    super.onInit();
  }

  // ✅ Validasi reply sesuai rules X
  void _validateReply() {
    final text = replyController.text.trim();
    charCount.value = replyController.text.length;

    // Reply valid jika:
    // 1. Tidak kosong setelah di-trim
    // 2. Panjang karakter >= minReplyLength
    // 3. Panjang karakter <= maxReplyLength
    isReplyValid.value =
        text.isNotEmpty &&
        text.length >= minReplyLength &&
        charCount.value <= maxReplyLength;
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
    // ✅ Validasi sebelum submit
    if (!isReplyValid.value) {
      Get.snackbar(
        "Invalid Reply",
        "Please write something before replying",
        // snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ✅ Cek jika sedang submit (prevent double submission)
    if (isSubmitting.value) return;

    final replyText = replyController.text.trim();
    final user = supabase.auth.currentUser;

    if (user == null) {
      Get.snackbar(
        "Error",
        "You must be logged in to reply",
        // snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      // ✅ Insert reply
      await supabase.from('replies').insert({
        'post_id': postId,
        'user_id': user.id,
        'content': replyText,
        'created_at': DateTime.now().toIso8601String(),
      });

      // ✅ Update comment_count
      await supabase.rpc(
        'increment_comment_count',
        params: {'post_id': postId},
      );

      Get.snackbar(
        "Success",
        "Reply submitted successfully",
        // snackPosition: SnackPosition.BOTTOM,
      );

      // ✅ Clear input setelah berhasil
      replyController.clear();

      // ✅ Refresh replies
      await fetchReplies(postId);

      // ✅ Update comment count di currentPost
      currentPost.value = currentPost.value.copyWith(
        commentCount: (currentPost.value.commentCount) + 1,
      );
    } catch (e) {
      print('⚠️ Error submitReply: $e');
      Get.snackbar(
        "Error",
        "Failed to submit reply. Please try again.",
        // snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
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
