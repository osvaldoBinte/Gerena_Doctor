class CreateNewOrderEntity {

  final List<ItemEntity> items;
  final bool usepoints;
  int? pointstouse;

  CreateNewOrderEntity({
    required this.items,
    required this.usepoints,
    this.pointstouse,
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