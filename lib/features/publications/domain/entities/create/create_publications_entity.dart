class CreatePublicationsEntity {
  final String description;
  final String isReview;
  final int? taggedDoctorId;
  final int ratings;
  final List<String> images;

  CreatePublicationsEntity({
    required this.description,
    required this.isReview,
    this.taggedDoctorId, 
    required this.ratings,
    required this.images,
  });
}