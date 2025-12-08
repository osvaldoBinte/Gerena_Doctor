import 'package:gerena/features/followers/domain/entities/follow_user_entity.dart';

class FollowUserModel extends FollowUserEntity {
  FollowUserModel({required super.userId, required super.username});
  factory FollowUserModel.fromJson(Map<String, dynamic> json) {
    return FollowUserModel(
      userId: json['userId'],
      username: json['nombreCompleto'],
    );
  }
}