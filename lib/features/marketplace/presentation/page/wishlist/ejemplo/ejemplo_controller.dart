import 'package:flutter/material.dart';
import 'package:gerena/common/widgets/simple_counter.dart';
import 'package:gerena/features/home/dashboard/widget/sidebar/modalbot/gerena_%20modal_bot.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:get/get.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistController2 extends GetxController {
  final RxMap<String, List<Map<String, dynamic>>> savedProductsByCategory = <String, List<Map<String, dynamic>>>{}.obs;
  
  final RxBool hasProgrammedList = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    savedProductsByCategory.value = {
      'Armonización facial': [
        {
          'id': '1',
          'name': 'CELOSOME IMPLANT',
          'price': '\$1,050.00 MXN',
          'image': 'assets/productoenventa.png',
          'description': 'Celosome está diseñado para el tratamiento facial y el rejuvenecimiento de la piel para brindar perfecta satisfacción y seguridad. Celosome te trae una piel visiblemente más joven y saludable.',
          'quantity': 8
        },
        {
          'id': '2',
          'name': 'CELOSOME MID',
          'price': '\$1,050.00 MXN',
          'image': 'assets/productoenventa.png',
          'description': 'Celosome está diseñado para el tratamiento facial y el rejuvenecimiento de la piel para brindar perfecta satisfacción y seguridad. Celosome te trae una piel visiblemente más joven y saludable.',
          'quantity': 8
        },
      ],
      'Labios': [
        {
          'id': '3',
          'name': 'RED VOLUMEN',
          'price': '\$1,500.00 MXN',
          'image': 'assets/productoenventa.png',
          'description': 'El AH reticulado, fabricado con su propia tecnología especializada, tiene efectos duraderos debido a su excelente resistencia enzimática a la descomposición lenta en el cuerpo a pesar de la pequeña cantidad de BDDE.',
          'quantity': 8,
          'programmed': true
        }
      ]
    };
    
    checkProgrammedLists();
  }
  
  void checkProgrammedLists() {
    hasProgrammedList.value = false;
    
    savedProductsByCategory.forEach((category, products) {
      for (var product in products) {
        if (product['programmed'] == true) {
          hasProgrammedList.value = true;
          break;
        }
      }
    });
  }
  
  void adjustQuantity(String categoryName, int productIndex, bool increase) {
    if (savedProductsByCategory.containsKey(categoryName)) {
      var products = savedProductsByCategory[categoryName]!;
      if (productIndex >= 0 && productIndex < products.length) {
        var product = Map<String, dynamic>.from(products[productIndex]);
        
        if (increase) {
          product['quantity'] = (product['quantity'] as int) + 1;
        } else if (product['quantity'] > 1) {
          product['quantity'] = (product['quantity'] as int) - 1;
        }
        
        products[productIndex] = product;
        savedProductsByCategory[categoryName] = List.from(products);
      }
    }
  }
  
  void programOrder(String categoryName) {
    if (savedProductsByCategory.containsKey(categoryName)) {
      var products = savedProductsByCategory[categoryName]!;
      for (int i = 0; i < products.length; i++) {
        var product = Map<String, dynamic>.from(products[i]);
        product['programmed'] = true;
        products[i] = product;
      }
      
      savedProductsByCategory[categoryName] = List.from(products);
      checkProgrammedLists();
    }
  }
  
  void removeProduct(String categoryName, int productIndex) {
    if (savedProductsByCategory.containsKey(categoryName)) {
      var products = List<Map<String, dynamic>>.from(savedProductsByCategory[categoryName]!);
      if (productIndex >= 0 && productIndex < products.length) {
        products.removeAt(productIndex);
        
        if (products.isEmpty) {
          savedProductsByCategory.remove(categoryName);
        } else {
          savedProductsByCategory[categoryName] = products;
        }
        
        checkProgrammedLists();
      }
    }
  }
}