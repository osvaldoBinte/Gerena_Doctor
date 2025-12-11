import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/review/domain/repositories/review_repository.dart';

class MyReviewUsecase {
  final ReviewRepository reviewRepository;
  MyReviewUsecase({required this.reviewRepository});
    Future<List< PublicationEntity>> execute() async {
      return await reviewRepository.myreview();
    }
}