class MedicationsEntity {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imagen;
  final String categoria;
  final String activo;
  MedicationsEntity({
   required this.id,
   required this.name,
   required this.description,
   required this.price,
   required this.stock,
   required this.imagen,
   required this.categoria,
   required this.activo

  });
  
}