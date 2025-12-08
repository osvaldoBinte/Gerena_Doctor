import 'package:gerena/features/followers/domain/entities/follow_status_entity.dart';

class FollowStatusModel extends FollowStatusEntity {
  FollowStatusModel({required super.isFollowing, required super.totalFollowers, required super.totalFollowing});
 factory FollowStatusModel.fromJson(Map<String, dynamic> json) {
    return FollowStatusModel(
      isFollowing: json['estaSiguiendo'],
      totalFollowers: json['totalSeguidores'],
      totalFollowing: json['totalSiguiendo'],
    );
  }
}