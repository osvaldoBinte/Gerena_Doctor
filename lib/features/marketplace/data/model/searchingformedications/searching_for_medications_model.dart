import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';

class SearchingForMedicationsModel extends MedicationsEntity {
  SearchingForMedicationsModel(
      {required super.id,
      required super.name,
      required super.description,
      required super.price,
      required super.stock,
       super.imagen,
      required super.categoria,
      required super.activo, required super.previousprice});

  factory SearchingForMedicationsModel.fromJson(Map<String, dynamic> json) {
    return SearchingForMedicationsModel(
        id: json['id']??0,
        name: json['nombre']??'',
        description: json['descripcion']??'',
        price: json['precio']??0.0,
        stock: json['stock']??0,
        imagen: json['imagen'],
        categoria: json['categoria']??'',
        activo: json['activo']??'',
        previousprice: json['precioAnterior'],
        
        );
        
  }
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'nombre':name,
      'descripcion':description,
      'precio':price,
      'stock':stock,
      'imagen':imagen,
      'categoria':categoria,
      'activo':activo,
      'precioAnterior':previousprice
    };
  }
}
