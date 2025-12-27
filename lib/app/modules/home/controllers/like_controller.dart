import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';
import 'package:xnusa_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:xnusa_mobile/app/modules/profile_page/controllers/profile_page_controller.dart';
import 'package:xnusa_mobile/app/modules/visit_user_profile_page/controllers/visit_user_profile_page_controller.dart';

class LikeController extends GetxController {
  final supabase = Supabase.instance.client;
  final _pending = <int>{}.obs;

  void _updateInList(
    RxList<PostModel> list,
    int postId,
    bool isLiked,
    int likeCount,
  ) {
    final i = list.indexWhere((p) => p.id == postId);
    if (i == -1) return;
    list[i] = list[i].copyWith(isLiked: isLiked, likeCount: likeCount);
    list.refresh();
  }

  void _syncEverywhere(int postId, bool isLiked, int likeCount) {
    if (Get.isRegistered<HomeController>()) {
      _updateInList(
        Get.find<HomeController>().posts,
        postId,
        isLiked,
        likeCount,
      );
    }
    if (Get.isRegistered<ProfilePageController>()) {
      final p = Get.find<ProfilePageController>();
      _updateInList(p.userPosts, postId, isLiked, likeCount);
      _updateInList(p.userLikes, postId, isLiked, likeCount);
    }
    if (Get.isRegistered<VisitUserProfileController>()) {
      _updateInList(
        Get.find<VisitUserProfileController>().userPosts,
        postId,
        isLiked,
        likeCount,
      );
    }
  }

  Future<void> toggleLikeOptimistic({
    required RxList<PostModel> postList,
    required PostModel post,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null || post.id == null) return;
    final postId = post.id!;

    if (_pending.contains(postId)) return;
    _pending.add(postId);

    final idx = postList.indexWhere((p) => p.id == postId);
    if (idx < 0) {
      _pending.remove(postId);
      return;
    }

    final current = postList[idx];
    final nextLiked = !current.isLiked;
    final nextCount =
        nextLiked
            ? current.likeCount + 1
            : (current.likeCount - 1 < 0 ? 0 : current.likeCount - 1);

    final snapshotBefore = current;

    // ✅ optimistic update ke list yang memanggil
    postList[idx] = current.copyWith(isLiked: nextLiked, likeCount: nextCount);
    postList.refresh();

    // ✅ sinkron ke halaman lain (Home/Profile/Visit) kalau ada
    _syncEverywhere(postId, nextLiked, nextCount);

    try {
      if (nextLiked) {
        await supabase.from('likes').upsert({
          'user_id': user.id,
          'post_id': postId,
          'created_at': DateTime.now().toIso8601String(),
        }, onConflict: 'user_id,post_id');
      } else {
        await supabase
            .from('likes')
            .delete()
            .eq('user_id', user.id)
            .eq('post_id', postId);
      }
    } catch (e) {
      // rollback
      postList[idx] = snapshotBefore;
      postList.refresh();
      _syncEverywhere(postId, snapshotBefore.isLiked, snapshotBefore.likeCount);
      debugPrint('❌ toggleLike failed: $e');
    } finally {
      _pending.remove(postId);
    }
  }
}
