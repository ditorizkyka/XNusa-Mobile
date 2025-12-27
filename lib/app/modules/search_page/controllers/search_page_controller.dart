import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPageController extends GetxController {
  final supabase = Supabase.instance.client;
  var searchResults = <Map<String, dynamic>>[].obs;

  final currentKeyword = ''.obs; // ✅ simpan keyword terakhir

  Future<void> searchUser(String keyword) async {
    final user = supabase.auth.currentUser;

    currentKeyword.value = keyword; // ✅ simpan keyword

    if (keyword.isEmpty || user == null) {
      searchResults.clear();
      return;
    }

    final response = await supabase
        .from('profiles')
        .select('id, username, display_name, profile_image_url')
        .ilike('username', '%$keyword%');

    final followingResponse = await supabase
        .from('follows')
        .select('following_id')
        .eq('follower_id', user.id);

    final followingIds =
        (followingResponse as List).map((e) => e['following_id']).toList();

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

    // cari index user di list
    final index = searchResults.indexWhere((u) => u['id'] == targetUserId);
    if (index == -1) return;

    final currentlyFollowed =
        (searchResults[index]['is_followed'] ?? false) as bool;

    try {
      // ✅ Optimistic update dulu biar UI langsung berubah
      searchResults[index]['is_followed'] = !currentlyFollowed;
      searchResults.refresh();

      if (currentlyFollowed) {
        await supabase
            .from('follows')
            .delete()
            .eq('follower_id', user.id)
            .eq('following_id', targetUserId);
      } else {
        await supabase.from('follows').insert({
          'follower_id': user.id,
          'following_id': targetUserId,
        });
      }
    } catch (e) {
      // ❌ kalau gagal, balikin lagi state-nya
      searchResults[index]['is_followed'] = currentlyFollowed;
      searchResults.refresh();
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onInit() {
    // reset state saat page dibuka
    searchResults.clear();
    currentKeyword.value = '';
    super.onInit();
  }
}
