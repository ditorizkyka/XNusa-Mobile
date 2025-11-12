import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPageController extends GetxController {
  final supabase = Supabase.instance.client;
  var searchResults = <Map<String, dynamic>>[].obs;

  Future<void> searchUser(String keyword) async {
    final user = supabase.auth.currentUser;
    if (keyword.isEmpty || user == null) {
      searchResults.clear();
      return;
    }

    // Cari user dengan username mirip
    final response = await supabase
        .from('profiles')
        .select('id, username, display_name, profile_image_url')
        .ilike('username', '%$keyword%');

    // Ambil semua following user login
    final followingResponse = await supabase
        .from('follows')
        .select('following_id')
        .eq('follower_id', user.id);

    final followingIds =
        (followingResponse as List).map((e) => e['following_id']).toList();

    // Tandai mana yang sudah difollow
    searchResults.assignAll(
      (response as List)
          .map((e) => Map<String, dynamic>.from(e))
          .map((u) => {...u, 'is_followed': followingIds.contains(u['id'])})
          .toList(),
    );
  }

  Future<void> toggleFollow(String targetUserId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final isFollowed =
        await supabase
            .from('follows')
            .select('id')
            .eq('follower_id', user.id)
            .eq('following_id', targetUserId)
            .maybeSingle();

    if (isFollowed != null) {
      // sudah follow → unfollow
      await supabase
          .from('follows')
          .delete()
          .eq('follower_id', user.id)
          .eq('following_id', targetUserId);
    } else {
      // belum follow → follow
      await supabase.from('follows').insert({
        'follower_id': user.id,
        'following_id': targetUserId,
      });
    }

    // refresh hasil search supaya UI ikut update
    await searchUser('');
  }
}
