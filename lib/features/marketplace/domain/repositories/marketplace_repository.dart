import 'package:gerena/features/marketplace/domain/entities/categories/categories_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/descuentopuntos/descuento_puntos_entity.dart';
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
   Future<List< OrderEntity>> myorders();
  Future<OrderEntity> orderbyID(int id);
    Future<RessponseNewOrderEntity> createaneworder(CreateNewOrderEntity createaneworder,int idAddresse,);

  Future<ShoppingCartResponseEntity> validatecart(ShoppingCartItemsEntity shoppingcartpostentity);
  Future<void> payorder(int orderId,String paymentMethodId);

  Future<void> deletepayorder(int orderId,String paymentMethodId);

  Future<OrderEntity> getMylastpaidorder() ;

  Future<DescuentoPuntosEntity> calculatediscountpoints(int  monto,int puntosAUsar) ;
}