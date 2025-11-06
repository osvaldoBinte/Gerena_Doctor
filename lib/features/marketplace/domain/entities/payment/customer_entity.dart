class CustomerEntity {
  final String id;
  final String email;
  final String? name;
  final String? phone;

  CustomerEntity({
    required this.id,
    required this.email,
    this.name,
    this.phone,
  });
}