class ViewAllPlansEntity {
  final int id;
  final String name;
  final String description;
  final double price;
  final String interval;
  final Caracteristicas caracteristicas;
  final bool activo;

  ViewAllPlansEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.interval,
    required this.caracteristicas,
    required this.activo,
  });
}

class Caracteristicas {
  final List<String> beneficios;
  final List<String>? destacados;

  Caracteristicas({
    required this.beneficios,
    this.destacados,
  });
}