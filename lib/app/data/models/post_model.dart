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

  // Data dari tabel profiles (join Supabase)
  final String? username;
  final String? profileImageUrl;

  // (opsional) data untuk menampilkan repost asal
  final PostModel? originalPost;

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

      // nested data dari join profiles
      username: json['profiles'] != null ? json['profiles']['username'] : null,
      profileImageUrl:
          json['profiles'] != null
              ? json['profiles']['profile_image_url']
              : null,

      // nested original post (kalau kamu ambil repost dengan join lagi)
      originalPost:
          json['original_post'] != null
              ? PostModel.fromJson(json['original_post'])
              : null,
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
  };

  static List<PostModel> listFromJson(List<dynamic> list) {
    return list.map((e) => PostModel.fromJson(e)).toList();
  }
}
