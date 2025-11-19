class CreateNewOrderEntity {

  final List<ItemEntity> items;

  CreateNewOrderEntity({
    required this.items,
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