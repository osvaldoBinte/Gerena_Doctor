import 'package:gerena/features/marketplace/domain/entities/categories/categories_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/create/create_new_order_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/create/ressponse_new_order_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/orders_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_items_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_post_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_response_entity.dart';

abstract class MarketplaceRepository {
  Future<List<CategoriesEntity>>categories();
  Future<List<MedicationsEntity>> searchingformedications(String categoria,String busqueda,);
    Future<List<MedicationsEntity>> medicinesonsale();

  Future<MedicationsEntity> getmedicineByID(int id);
   Future<OrderEntity> myorders();
  Future<OrderEntity> orderbyID(int id);
    Future<RessponseNewOrderEntity> createaneworder(CreateNewOrderEntity createaneworder);

  Future<ShoppingCartResponseEntity> validatecart(ShoppingCartItemsEntity shoppingcartpostentity);
  Future<void> payorder(int orderId,String paymentMethodId);
}