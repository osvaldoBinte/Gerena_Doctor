import 'package:flutter/material.dart';
import 'package:gerena/common/widgets/simple_counter.dart';
import 'package:gerena/page/dashboard/widget/modalGuardarProducto/modal_guardar_producto.dart';
import 'package:gerena/page/dashboard/widget/sidebar/modalbot/gerena_%20modal_bot.dart';
import 'package:gerena/page/store/cartPage/GlobalShopInterface.dart';
import 'package:get/get.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistController extends GetxController {
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

class SavedProductsContent extends StatelessWidget {
  final VoidCallback onBackPressed;
  
  SavedProductsContent({
    Key? key, 
    required this.onBackPressed,
  }) : super(key: key);
  
  final WishlistController controller = Get.put(WishlistController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorfondo,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Container(
          color: GerenaColors.backgroundColor,
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Mis listas',
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textTertiaryColor,

                  ),
                ),
              ),
              
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: controller.savedProductsByCategory.entries.map((entry) {
                  final categoryName = entry.key;
                  final products = entry.value;
                  final isProgrammed = products.any((p) => p['programmed'] == true);
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '-$categoryName',
                            style: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: GerenaColors.textTertiaryColor,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),

                            child: isProgrammed
                                ? Row(
                                    children: [
                                      Text(
                                        'Programado',
                                        style: GoogleFonts.rubik(
                                          fontSize: 14,
                                          color: GerenaColors.textTertiaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      GerenaColors.widgetButton(
                                        text: 'EDITAR',
                                        showShadow: false,
                                      ),
                                    ],
                                  )
                                : GerenaColors.widgetButton(
                                    text: 'PROGRAMAR PEDIDO',
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const ModalGuardarProducto();
                                        },
                                      );
                                    },
                                    customShadow: GerenaColors.mediumShadow,
                                  ),
                          )
                        ],
                      ),
                      
                      SizedBox(height: 8),
                      Column(
                        children: List.generate(products.length, (index) {
                          final product = products[index];
                          return _buildProductItem(
                            product: product,
                            categoryName: categoryName,
                            index: index,
                            isProgrammed: product['programmed'] == true,
                          );
                        }),
                      ),
                      
                      SizedBox(height: 24),
                    ],
                  );
                }).toList(),
              )),
            ],
          ),
        ),
      )
    );
  }
  
  Widget _buildProductItem({
    required Map<String, dynamic> product, 
    required String categoryName, 
    required int index,
    bool isProgrammed = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
              product['image'],
              fit: BoxFit.contain,
              height: 100,
            ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: GoogleFonts.rubik(
                      fontSize: 16,
                      color: GerenaColors.textTertiaryColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    product['price'],
                    style: GoogleFonts.rubik(

                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: GerenaColors.textTertiaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product['description'],
                    style: GoogleFonts.rubik(
                      fontSize: 12,
                      color: GerenaColors.textTertiaryColor,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => controller.removeProduct(categoryName, index),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/guardar.png',
                      width: 16,
                      height: 16,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                
                SizedBox(height: 40),
                Padding(
            padding: EdgeInsets.symmetric(horizontal: 40,),

            child: simpleCounter(),
                )
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}