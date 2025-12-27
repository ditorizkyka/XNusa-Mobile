class ReplyModel {
  final int? id;
  final int? postId;
  final String? userId;
  final String? content;
  final DateTime? createdAt;
  final String? username; // ← Make nullable
  final String? profileImageUrl; // ← Make nullable

  ReplyModel({
    this.id,
    this.postId,
    this.userId,
    this.content,
    this.createdAt,
    this.username,
    this.profileImageUrl,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    final profiles = json['profiles'] as Map<String, dynamic>?;

    return ReplyModel(
      id: json['id'] as int?,
      postId: json['post_id'] as int?,
      userId: json['user_id'] as String?,
      content: json['content'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      username: profiles?['username'] as String?, // ← Safe null access
      profileImageUrl:
          profiles?['profile_image_url'] as String?, // ← Safe null access
    );
  }
}
