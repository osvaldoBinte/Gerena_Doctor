import 'package:gerena/features/review/domain/entities/my_review_entity.dart';

abstract class ReviewRepository  {
  Future<List< MyReviewEntity>> myreview();

}