import 'package:gerena/features/publications/domain/entities/myposts/reactions_entity.dart';

class ReactionsModel extends ReactionsEntity {
  ReactionsModel({
    required super.likes,
    required super.ilove,
    required super.amazesme,
    required super.ineedit,
    required super.total,
  });

  factory ReactionsModel.fromJson(Map<String, dynamic> json) {
    return ReactionsModel(
      likes: json["like"] ?? 0,
      ilove: json["meEncanta"] ?? 0,
      amazesme: json["meAsombra"] ?? 0,
      ineedit: json["loNecesito"] ?? 0,
      total: json["total"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "like": likes,
      "meEncanta": ilove,
      "meAsombra": amazesme,
      "loNecesito": ineedit,
      "total": total,
    };
  }
}
