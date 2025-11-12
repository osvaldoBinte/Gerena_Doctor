import 'package:gerena/features/marketplace/domain/entities/addresses/addresses_entity.dart';

class AddressModel extends AddressesEntity {
  AddressModel(
      {
       super.id,
       super.doctorId,
      required super.fullName,
      required super.phone,
      required super.street,
      required super.exteriorNumber,
      required super.interiorNumber,
      required super.neighborhood,
      required super.city,
      required super.state,
      required super.postalCode,
      required super.references});

factory AddressModel.fromJson(Map<String, dynamic> json) {
  return AddressModel(
    id: json['id'] ?? 0,
    doctorId: json['doctorId'] ?? 0,
    fullName: json['nombreCompleto'] ?? '',
    phone: json['telefono'] ?? '',
    street: json['calle'] ?? '',
    exteriorNumber: json['numeroExterior'] ?? ' ',
    interiorNumber: json['numeroInterior'] ?? ' ',
    neighborhood: json['colonia'] ?? ' ',
    city: json['ciudad'] ?? ' ',
    state: json['estado'] ?? ' ',
    postalCode: json['codigoPostal'] ?? ' ',
    references: json['referencias'] ?? ' ',
  );
}

  factory AddressModel.fromEntity(AddressesEntity entity) {
    return AddressModel(
     
      fullName: entity.fullName,
      phone: entity.phone,
      street: entity.street,
      exteriorNumber: entity.exteriorNumber,
      interiorNumber: entity.interiorNumber,
      neighborhood: entity.neighborhood,
      city: entity.city,
      state: entity.state,
      postalCode: entity.postalCode,
      references: entity.references,
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'street': street,
      'exteriorNumber': exteriorNumber,
      'interiorNumber': interiorNumber,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'referencias': references,
    };
  }
}
