import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/features/marketplace/data/datasources/marketplace_data_sources_imp.dart';
import 'package:gerena/features/marketplace/domain/entities/categories/categories_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/medications/medications_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/create/create_new_order_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/create/ressponse_new_order_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/orders/orders_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_items_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_post_entity.dart';
import 'package:gerena/features/marketplace/domain/entities/shoppingcart/shopping_cart_response_entity.dart';
import 'package:gerena/features/marketplace/domain/repositories/marketplace_repository.dart';

class MarketplaceRepositoryImp extends MarketplaceRepository {
  final MarketplaceDataSourcesImp marketplaceDataSourcesImp;
  final AuthService authService = AuthService();
  MarketplaceRepositoryImp({required this.marketplaceDataSourcesImp});
  
  @override
  Future<List<CategoriesEntity>> categories()async {
    final session = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await marketplaceDataSourcesImp.getcategories(session);
  }

  @override
  Future<MedicationsEntity> getmedicineByID(int id) async {
    final session = await authService.getToken()?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await marketplaceDataSourcesImp.getmedicationsby(id, session);
  }

  @override
   Future<List< OrderEntity>> myorders() async {
     final session = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
     return await marketplaceDataSourcesImp.myorders(session);
  }


  @override
  Future<List<MedicationsEntity>> searchingformedications( String categoria, String busqueda) async {
    final session = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await marketplaceDataSourcesImp.searchingformedications( categoria, busqueda, session);
  }
  
  @override
  Future<OrderEntity> orderbyID(int id) async {
    final session = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await marketplaceDataSourcesImp.getordersbyid(session, id);
  }
  
  @override
  Future<List<MedicationsEntity>> medicinesonsale() async {
    final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await marketplaceDataSourcesImp.medicinesonsale(token);
  }
  


  @override
  Future<ShoppingCartResponseEntity> validatecart(ShoppingCartItemsEntity shoppingcartpostentity) async {
        final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));

    return await marketplaceDataSourcesImp.validatecart(shoppingcartpostentity, token);
  }

  @override
  Future<RessponseNewOrderEntity> createaneworder(CreateNewOrderEntity createaneworder,int idAddresse,) async {
    final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await marketplaceDataSourcesImp.createaneworder(createaneworder,idAddresse,token);
  }
  
  @override
  Future<void> payorder(int orderId,String paymentMethodId) async {
    final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await marketplaceDataSourcesImp.payorder(orderId, token,paymentMethodId);
  }
  
  @override
  Future<OrderEntity> getMylastpaidorder() async {
    final token = await authService.getToken() ?? (throw Exception('No hay sesión activa. El usuario debe iniciar sesión.'));
    return await marketplaceDataSourcesImp.getMylastpaidorder(token);
  }
 
}
