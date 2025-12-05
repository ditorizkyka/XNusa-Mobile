import 'package:meta/meta.dart';

@immutable
class PostModel {
  final int? id;
  final String? userId;
  final String? username;
  final String? displayName;
  final String? profileImageUrl;
  final String? description;
  final String? imageUrl;
  final DateTime? createdAt;

  // Statistik post
  final int likeCount;
  final int commentCount;
  final List? comments;

  // Status interaktif
  final bool isLiked;
  final bool isFollowed;

  const PostModel({
    this.id,
    this.userId,
    this.username,
    this.displayName,
    this.profileImageUrl,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.comments,
    this.isLiked = false,
    this.isFollowed = false,
  });

  /// Factory dari JSON Supabase
  factory PostModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] ?? {};
    return PostModel(
      id: json['id'] as int?,
      userId: json['user_id'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,

      // relasi profile
      username: profile['username'],
      displayName: profile['display_name'],
      profileImageUrl: profile['profile_image_url'],

      // tambahan status
      isLiked: json['is_liked'] ?? false,
      isFollowed: json['is_followed'] ?? false,
    );
  }

  /// Untuk konversi kembali ke Map (opsional)
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'description': description,
    'image_url': imageUrl,
    'created_at': createdAt?.toIso8601String(),
    'like_count': likeCount,
    'comment_count': commentCount,
    'profiles': {
      'username': username,
      'display_name': displayName,
      'profile_image_url': profileImageUrl,
    },
    'is_liked': isLiked,
    'is_followed': isFollowed,
  };

  PostModel copyWith({
    int? id,
    String? userId,
    String? username,
    String? displayName,
    String? profileImageUrl,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    int? likeCount,
    int? commentCount,
    int? parentPostId,
    int? repostedFrom,
    bool? isLiked,
    bool? isFollowed,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }
}
