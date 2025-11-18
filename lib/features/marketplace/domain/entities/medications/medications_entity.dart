class MedicationsEntity {
  final int id;
  final String? name;
  final String? description;
  final List<String>? features;
  final double? price;
  final double? previousPrice;
  final bool? onSale;
  final double? discountPercentage;
  final int? stock;
  final List<String>? images;
  final String? technicalSheetUrl;
  final String? termsUrl;
  final String? category;
  final bool? isActive;

  MedicationsEntity({
    required this.id,
    this.name,
    this.description,
    this.features,
    this.price,
    this.previousPrice,
    this.onSale,
    this.discountPercentage,
    this.stock,
    this.images,
    this.technicalSheetUrl,
    this.termsUrl,
    this.category,
    this.isActive,
  });
}
