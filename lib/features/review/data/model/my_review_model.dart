import 'package:gerena/features/review/domain/entities/my_review_entity.dart';

class MyReviewModel extends MyReviewEntity {
  MyReviewModel({
     super.id,
     super.doctorName,
     super.clientName,
     super.rating,
     super.comment,
     super.creationDate,
  });

  factory MyReviewModel.fromJson(Map<String, dynamic> json) {
    return MyReviewModel(
      id: json['id'],
      doctorName: json['doctorNombre'] ?? '',
      clientName: json['clienteNombre'] ?? '',
      rating: json['calificacion'] ?? 0,
      comment: json['comentario'] ?? '',
      creationDate: json['fechaCreacion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorNombre': doctorName,
      'clienteNombre': clientName,
      'calificacion': rating,
      'comentario': comment,
      'fechaCreacion': creationDate,
    };
  }
  factory MyReviewModel.fromEntity(MyReviewEntity entity){
    return MyReviewModel(id: entity.id, doctorName: entity.doctorName, clientName: entity.clientName, rating: entity.rating, comment: entity.comment, creationDate: entity.creationDate);
  }
}
