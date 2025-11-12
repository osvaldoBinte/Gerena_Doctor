class CreateNewOrderEntity {

  final List<ItemEntity> items;
  final String direccionEnvio;
  final String ciudad;
  final int codigoPostal;

  CreateNewOrderEntity({
    required this.items,
    required this.direccionEnvio,
    required this.ciudad,
    required this.codigoPostal,
  });


}
class ItemEntity {
  final int medicamentoId;
  final int quantity;

  ItemEntity({
    required this.medicamentoId,
    required this.quantity,
  });
}