class AddressesEntity {
  int ? id;
   int?doctorId;
  final String fullName;
  final String phone;
  final String street;
  final String exteriorNumber;
  final String interiorNumber;
  final String neighborhood;
  final String city;
  final String state;
  final String postalCode;
  final String references;

  AddressesEntity({
    this.id,
     this.doctorId,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.exteriorNumber,
    required this.interiorNumber,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.references,
  });
}
