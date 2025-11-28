class DescuentoPuntosEntity {
  final  int availablePoints;
  final int pointsToUse;
  final double totalDiscount;
  final double originalTotal;
  final double totalWithDiscount;
  DescuentoPuntosEntity({
    required this.availablePoints,
    required this.pointsToUse,
    required this.totalDiscount,
    required this.originalTotal,
    required this.totalWithDiscount
  });
}