import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';


abstract class ReviewRepository  {
  Future<List< PublicationEntity>> myreview();

}