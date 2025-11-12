class PostModel {
  final int? id;
  final String? userId;
  final String? description;
  final String? imageUrl;
  final DateTime? createdAt;
  final int? likeCount;
  final int? replyCount;
  final int? repostCount;
  final int? repostedFrom;
  final String? username;
  final String? profileImageUrl;
  final PostModel? originalPost;

  // ⬇️ status like untuk UI
  final bool isLiked;

  PostModel({
    this.id,
    this.userId,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.likeCount,
    this.replyCount,
    this.repostCount,
    this.repostedFrom,
    this.username,
    this.profileImageUrl,
    this.originalPost,
    this.isLiked = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['user_id'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      likeCount: json['like_count'] ?? 0,
      replyCount: json['reply_count'] ?? 0,
      repostCount: json['repost_count'] ?? 0,
      repostedFrom: json['reposted_from'],
      username: json['profiles'] != null ? json['profiles']['username'] : null,
      profileImageUrl:
          json['profiles'] != null
              ? json['profiles']['profile_image_url']
              : null,
      originalPost:
          json['original_post'] != null
              ? PostModel.fromJson(json['original_post'])
              : null,
      isLiked: json['is_liked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'description': description,
    'image_url': imageUrl,
    'created_at': createdAt?.toIso8601String(),
    'like_count': likeCount,
    'reply_count': replyCount,
    'repost_count': repostCount,
    'reposted_from': repostedFrom,
    'profiles': {'username': username, 'profile_image_url': profileImageUrl},
    'is_liked': isLiked,
  };

  // ⬇️ untuk update immutable model
  PostModel copyWith({
    int? id,
    String? userId,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    int? likeCount,
    int? replyCount,
    int? repostCount,
    int? repostedFrom,
    String? username,
    String? profileImageUrl,
    PostModel? originalPost,
    bool? isLiked,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount ?? this.replyCount,
      repostCount: repostCount ?? this.repostCount,
      repostedFrom: repostedFrom ?? this.repostedFrom,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      originalPost: originalPost ?? this.originalPost,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  static List<PostModel> listFromJson(List<dynamic> list) =>
      list.map((e) => PostModel.fromJson(e)).toList();
}
