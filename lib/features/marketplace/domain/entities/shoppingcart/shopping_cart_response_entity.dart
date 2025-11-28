class ShoppingCartResponseEntity {
  final double totalActual;
  final int gastoEnvio;
  final int iva;
  final List<ItemEntity> itenms;
  ShoppingCartResponseEntity({required this.totalActual, required this.gastoEnvio,required this.iva,required this.itenms});
}

class ItemEntity {
  final int medicamentoId;
  final String nombreMedicamento;
  final int cantidadSolicitada;
  final double precioActual;
  final double precioAnterior;
  final bool sinStock;
  String? alerta;
  String? imagen;
  String? categoria;
  bool? oferta;

  ItemEntity(
      {required this.medicamentoId,
      required this.nombreMedicamento,
      required this.cantidadSolicitada,
      required this.precioActual,
      required this.precioAnterior,
      required this.sinStock,
      this.alerta,
      this.categoria,
      this.imagen,
      this.oferta});
}
