import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryByIdPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryByIdPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorFondo,
      appBar: AppBar(
        backgroundColor: GerenaColors.backgroundColorFondo,
        elevation: 4,
        shadowColor: GerenaColors.shadowColor,
        automaticallyImplyLeading:false,
        title: Row(
          children: [
            Text(
              'GERENA',
              style: GoogleFonts.rubik(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            Container(
              width: 140,
              child: GerenaColors.createSearchContainer(
                height: 26,
                heightcontainer: 15,
                iconSize: 18,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header fijo (wishlist button)
            Container(
              padding: EdgeInsets.all(GerenaColors.paddingMedium),
              child:Row(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap:Get.back,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: GerenaColors.secondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              child: const Icon(
                                                Icons.arrow_back,
                                                color: GerenaColors.textLightColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'RELLENO FACIAL',
                                              style: GoogleFonts.rubik(
                                                color: GerenaColors.textPrimaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
            ),
            
                    Divider(height: 2, color: GerenaColors.dividerColor),

            // Contenido con scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true, // Importante: mantén esto
                  physics: const NeverScrollableScrollPhysics(), // Desactiva el scroll del GridView
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final catalogProducts = [
                      {'name': 'CELOSOME IMPLANT', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'CELOSOME MID', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'CELOSOME SOFT', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'CELOSOME STRONG', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'DERMA EVOLUTION', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'INNOTOX', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'LIRAFIT SEMAGLUTIDA', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'LINURASE', 'price': '2,200.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'DERMA WRINKLES', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'DERMA EVOLUTION', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'GLAM FILL', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                      {'name': 'JADE CAINE', 'price': '1,000.00 MXN', 'image': 'assets/productoenventa.png'},
                    ];
                    
                    return _buildProductCard(catalogProducts[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, String> product) {
    final bool hasDiscount = product['hasDiscount'] == 'true';
    
    return GestureDetector(
     // onTap: () => navigationController.navigateToProductDetail(product),
      child: Container(
        decoration: BoxDecoration(
          color: GerenaColors.cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage('assets/tienda-producto.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: 'product-${product['name']}',
                      child: Image.asset(
                        product['image']!,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
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
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product['name']!,
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: GerenaColors.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.grey),
                        onPressed: () {},
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  
                  if (hasDiscount) ...[
                    Text(
                      product['price']!,
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: GerenaColors.textDarkColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      product['oldPrice']!,
                      style: GoogleFonts.rubik(
                        fontSize: 10,
                        color: GerenaColors.descuento,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: GerenaColors.descuento,
                      ),
                    ),
                   
                  ] else ...[
                    Text(
                      product['price']!,
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: GerenaColors.textDarkColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                     // onTap: () => navigationController.navigateToProductDetail(product),
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: GerenaColors.buttoninformation, 
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          ' VER INFORMACIÓN ',
                          style: GoogleFonts.rubik(
                            color: GerenaColors.textLightColor, 
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}