// 📁 File: visit_user_profile_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xnusa_mobile/app/data/models/post_model.dart';
import 'package:xnusa_mobile/app/modules/home/controllers/like_controller.dart';

class VisitUserProfileController extends GetxController {
  final String userId;
  var followers = <Map<String, dynamic>>[].obs;
  var followersCount = 0.obs;
  var isLoadingFollowers = false.obs;

  VisitUserProfileController({required this.userId});

  final supabase = Supabase.instance.client;

  var userData = {}.obs;
  var userPosts = <PostModel>[].obs;
  var isLoading = false.obs;
  var isLoadingPosts = false.obs;
  var isFollowed = false.obs;

  final likeC = Get.put(LikeController());

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  /// 🔹 Load semua data user (profile + posts + follow status)
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;

      await Future.wait([
        fetchUserData(),
        fetchUserPosts(),
        checkFollowStatus(),
        fetchFollowersVisitedUser(), // ✅ tambah ini
      ]);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Ambil data profil user
  Future<void> fetchUserData() async {
    try {
      final response =
          await supabase
              .from('profiles')
              .select()
              .eq('id', userId)
              .maybeSingle();

      if (response != null) {
        userData.value = response;
      }
    } catch (e) {
      print('❌ Error fetchUserData: $e');
    }
  }

  /// 🔹 Ambil semua post milik user ini
  Future<void> fetchUserPosts() async {
    try {
      isLoadingPosts.value = true;

      final currentUser = supabase.auth.currentUser;

      final response = await supabase
          .from('posts')
          .select('''
            *,
            profiles(username, profile_image_url),
            likes(user_id)
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      userPosts.value =
          (response as List).map((post) {
            return PostModel.fromJson({
              ...post,
              'is_liked': (post['likes'] as List).any(
                (like) => like['user_id'] == currentUser?.id,
              ),
            });
          }).toList();
    } catch (e) {
      print('❌ Error fetchUserPosts: $e');
    } finally {
      isLoadingPosts.value = false;
    }
  }

  /// 🔹 Cek apakah user login sudah follow user ini
  Future<void> checkFollowStatus() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) return;

      final response =
          await supabase
              .from('follows')
              .select()
              .eq('follower_id', currentUser.id)
              .eq('following_id', userId)
              .maybeSingle();

      isFollowed.value = response != null;
    } catch (e) {
      print('❌ Error checkFollowStatus: $e');
    }
  }

  /// 🔹 Toggle Follow/Unfollow
  Future<void> toggleFollow() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) return;

      if (isFollowed.value) {
        // Unfollow
        await supabase
            .from('follows')
            .delete()
            .eq('follower_id', currentUser.id)
            .eq('following_id', userId);

        isFollowed.value = false;
        Get.snackbar('Success', 'Unfollowed successfully');
      } else {
        // Follow
        await supabase.from('follows').insert({
          'follower_id': currentUser.id,
          'following_id': userId,
        });

        isFollowed.value = true;
        Get.snackbar('Success', 'Followed successfully');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// 🔹 Toggle like post
  Future<void> toggleLike(PostModel post) async {
    await likeC.toggleLikeOptimistic(postList: userPosts, post: post);
  }

  Future<void> fetchFollowersVisitedUser() async {
    try {
      isLoadingFollowers.value = true;

      final res = await supabase
          .from('follows')
          .select('''
          follower_id,
          created_at,
          profiles:profiles!follows_follower_id_fkey(
            id,
            username,
            display_name,
            profile_image_url,
            isVerified
          )
        ''')
          .eq('following_id', userId)
          .order('created_at', ascending: false);

      final list = (res as List);

      followers.value =
          list.map((row) {
            final profile = row['profiles'] as Map<String, dynamic>?;
            return {
              'follower_id': row['follower_id'],
              'created_at': row['created_at'],
              'profile': profile, // ✅ konsisten seperti profile page
            };
          }).toList();

      followersCount.value = followers.length;
    } catch (e) {
      print("❌ Error fetchFollowersVisitedUser: $e");
    } finally {
      isLoadingFollowers.value = false;
    }
  }
}
