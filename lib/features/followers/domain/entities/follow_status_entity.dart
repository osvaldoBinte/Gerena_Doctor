class FollowStatusEntity {
   bool? isFollowing;
  final int totalFollowers;
  final int totalFollowing;

  FollowStatusEntity({
     this.isFollowing,
    required this.totalFollowers,
    required this.totalFollowing,
  });

}
