class PostReactionEntity {
  final int userId;
  final String? nameuser;
  final String? fotouser;
  final String type;

  PostReactionEntity({
    required this.userId,
     this.nameuser,
     this.fotouser,
    required this.type,
  });
}
