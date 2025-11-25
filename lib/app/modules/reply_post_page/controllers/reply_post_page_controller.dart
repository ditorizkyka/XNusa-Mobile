import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';
import 'package:xnusa_mobile/app/data/models/reply_model.dart';

class ReplyPostPageController extends GetxController {
  final supabase = Supabase.instance.client;
  final replyController = TextEditingController();
  final isLoading = false.obs;
  RxInt charCount = 0.obs;
  final replies = <ReplyModel>[].obs;

  //TODO: Implement ReplyPostPageController

  final count = 0.obs;
  @override
  void onInit() {
    replyController.addListener(() {
      charCount.value = replyController.text.length;
    });
    super.onInit();
  }

  Future<void> submitReply(PostModel post) async {
    final replyText = replyController.text.trim();
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase.from('replies').insert({
        'user_id': user.id,
        'content': replyText,
        'post_id': post.id,
        'created_at': DateTime.now().toIso8601String(),
      });
      Get.snackbar("Success", "Reply submitted successfully");
      replyController.clear();
      await fetchReplies(post.id!);
    } catch (e) {
      print('⚠️ Error addPost: $e');
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

      // Process the response as needed
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
    super.onClose();
  }

  void increment() => count.value++;
}
