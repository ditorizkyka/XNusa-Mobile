import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FollowController extends GetxController {
  final supabase = Supabase.instance.client;

  // Map berisi status follow per user_id
  final follows = <String, bool>{}.obs;

  bool isFollowed(String userId) => follows[userId] ?? false;

  @override
  void onInit() {
    super.onInit();
    loadFollowStatus(); // ✅ PERBAIKAN: langsung panggil tanpa Get.put
  }

  /// ✅ Ambil semua user yang di-follow oleh user login
  Future<void> loadFollowStatus() async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) return;

    final data = await supabase
        .from('follows')
        .select('following_id')
        .eq('follower_id', currentUser.id);

    // ubah ke map reactive
    final Map<String, bool> newMap = {};
    for (final row in data) {
      newMap[row['following_id']] = true;
    }

    follows.assignAll(newMap);
    follows.refresh();
  }

  /// Toggle follow / unfollow
  Future<void> toggleFollowUser(String targetUserId) async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) return;

    final isNowFollowed = follows[targetUserId] ?? false;

    final existing =
        await supabase
            .from('follows')
            .select('id')
            .eq('follower_id', currentUser.id)
            .eq('following_id', targetUserId)
            .maybeSingle();

    if (existing == null && !isNowFollowed) {
      // follow
      await supabase.from('follows').insert({
        'follower_id': currentUser.id,
        'following_id': targetUserId,
      });
      follows[targetUserId] = true;
    } else if (existing != null && isNowFollowed) {
      // unfollow
      await supabase.from('follows').delete().eq('id', existing['id']);
      follows[targetUserId] = false;
    } else {
      follows[targetUserId] = !isNowFollowed;
    }

    follows.refresh();
  }
}
