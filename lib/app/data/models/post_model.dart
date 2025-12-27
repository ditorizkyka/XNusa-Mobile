import 'package:meta/meta.dart';

@immutable
class PostModel {
  final int? id;
  final String? userId;

  // relasi profiles
  final String? username;
  final String? displayName;
  final String? profileImageUrl;

  // konten post
  final String? description;
  final String? imageUrl;
  final DateTime? createdAt;

  // statistik
  final int likeCount;
  final int commentCount;

  // status interaktif
  final bool isLiked;
  final bool isFollowed;

  // ✅ badge verified (dari profiles.isVerified)
  final bool isVerified;

  // ✅ avatar preview (max 2) dari user yang reply
  final List<String> replyAvatarUrls;

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
    this.isLiked = false,
    this.isFollowed = false,
    this.isVerified = false,
    this.replyAvatarUrls = const [],
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final profile = (json['profiles'] ?? {}) as Map;

    // ✅ parse reply avatar urls
    final replyAvatars =
        (json['reply_avatar_urls'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];

    // ✅ verified bisa dikirim via json['is_verified'] atau langsung dari profiles.isVerified
    final verifiedFromProfile = (profile['isVerified'] as bool?) ?? false;
    final verifiedFromJson = (json['is_verified'] as bool?);

    return PostModel(
      id: json['id'] as int?,
      userId: json['user_id'] as String?,

      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString())
              : null,

      likeCount: (json['like_count'] as int?) ?? 0,
      commentCount: (json['comment_count'] as int?) ?? 0,

      username: profile['username'] as String?,
      displayName: profile['display_name'] as String?,
      profileImageUrl: profile['profile_image_url'] as String?,

      isLiked: (json['is_liked'] as bool?) ?? false,
      isFollowed: (json['is_followed'] as bool?) ?? false,

      isVerified: verifiedFromJson ?? verifiedFromProfile,
      replyAvatarUrls: replyAvatars,
    );
  }

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
      'isVerified': isVerified,
    },
    'is_liked': isLiked,
    'is_followed': isFollowed,
    'reply_avatar_urls': replyAvatarUrls,
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
    bool? isLiked,
    bool? isFollowed,
    bool? isVerified,
    List<String>? replyAvatarUrls,
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
      isVerified: isVerified ?? this.isVerified,
      replyAvatarUrls: replyAvatarUrls ?? this.replyAvatarUrls,
    );
  }
}
