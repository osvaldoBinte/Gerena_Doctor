class ShoppingCartResponseEntity {
  final double totalActual;
  final List<ItemEntity> itenms;
  ShoppingCartResponseEntity({
    required this.totalActual,
    required this.itenms
  });
}
class ItemEntity{
  final int medicamentoId;
  final String nombreMedicamento;
  final int cantidadSolicitada;
  final double precioActual;
  final double precioAnterior;
  final bool sinStock;
  String ? descripcion;

  ItemEntity({
    required this.medicamentoId,
    required this.nombreMedicamento,
    required this.cantidadSolicitada,
    required this.precioActual,
    required this.precioAnterior,
    required this.sinStock,
    this.descripcion
  });
}