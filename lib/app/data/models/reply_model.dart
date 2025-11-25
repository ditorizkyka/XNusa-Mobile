class ReplyModel {
  final int id;
  final String userId;
  final int postId;
  final String content;
  final String username;
  final String profileImageUrl;
  final DateTime createdAt;

  ReplyModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        postId = json['post_id'],
        content = json['content'],
        username = json['profiles']['username'],
        profileImageUrl = json['profiles']['profile_image_url'],
        createdAt = DateTime.parse(json['created_at']);
}
