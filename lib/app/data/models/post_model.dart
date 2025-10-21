class PostModel {
  final int id;
  final String userId;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final String? username;
  final String? profileImageUrl;

  PostModel({
    required this.id,
    required this.userId,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
    this.username,
    this.profileImageUrl,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['user_id'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      username: json['profiles']?['username'],
      profileImageUrl: json['profiles']?['profile_image_url'],
    );
  }
}
