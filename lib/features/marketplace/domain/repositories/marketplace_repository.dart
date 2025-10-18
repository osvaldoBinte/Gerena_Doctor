import 'package:gerena/features/marketplace/domain/entities/categories/categories_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/orders_entity.dart';

abstract class MarketplaceRepository {
  Future<List<CategoriesEntity>>categories();
  Future<List<MedicationsEntity>> searchingformedications(String categoria,String busqueda,);
  Future<MedicationsEntity> getmedicineByID(int id);
   Future<OrderEntity> myorders();
  Future<OrderEntity> orderbyID(int id);
}