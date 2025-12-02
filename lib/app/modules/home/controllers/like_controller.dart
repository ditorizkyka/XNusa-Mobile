import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';

class LikeController extends GetxController {
  final supabase = Supabase.instance.client;

  // daftar post yang sedang di-like supaya tidak bisa spam tap
  final _pending = <int>{}.obs;

  /// Toggle like (optimistic update)
  Future<void> toggleLikeOptimistic({
    required RxList<PostModel> postList,
    required PostModel post,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null || post.id == null) return;
    final postId = post.id!;

    // cegah spam tap
    if (_pending.contains(postId)) return;
    _pending.add(postId);

    // cari index post di list yang dikirim
    final idx = postList.indexWhere((p) => p.id == postId);
    if (idx < 0) {
      _pending.remove(postId);
      return;
    }

    // ===== OPTIMISTIC UPDATE UI =====
    final current = postList[idx];
    final nextLiked = !current.isLiked;
    final currentCount = current.likeCount;
    final nextCount =
        nextLiked ? currentCount + 1 : (currentCount - 1).clamp(0, 1 << 31);

    // snapshot buat rollback kalau gagal
    final snapshotBefore = current;
    postList[idx] = current.copyWith(isLiked: nextLiked, likeCount: nextCount);
    postList.refresh();

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
      // rollback kalau gagal
      postList[idx] = snapshotBefore;
      postList.refresh();
      debugPrint('❌ toggleLike failed: $e');
    } finally {
      _pending.remove(postId);
    }
  }
}
