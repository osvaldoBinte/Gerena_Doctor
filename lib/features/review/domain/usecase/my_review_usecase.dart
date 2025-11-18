import 'package:gerena/features/review/domain/entities/my_review_entity.dart';
import 'package:gerena/features/review/domain/repositories/review_repository.dart';

class MyReviewUsecase {
  final ReviewRepository reviewRepository;
  MyReviewUsecase({required this.reviewRepository});
    Future<List< MyReviewEntity>> execute() async {
      return await reviewRepository.myreview();
    }
}