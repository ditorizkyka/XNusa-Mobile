import 'package:hive/hive.dart';

part 'userModel.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  String uid;

  @HiveField(1)
  String email;

  @HiveField(2)
  String? displayName; // dari tabel profiles Supabase

  @HiveField(3)
  bool isLoggedIn;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    required this.isLoggedIn,
  });
}
