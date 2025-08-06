import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'product_detail_controller.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, String> product;
  
  const ProductDetailPage({
    Key? key, 
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializar el controlador
    final controller = Get.put(ProductDetailController());
    
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorfondo,
     
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container principal que contiene el detalle del producto
            Container(
              margin: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contenedor para la imagen del producto (izquierda)
                  Expanded(
                    flex: 1,
                    child: ProductImageSection(
                      product: product, 
                      controller: controller,
                    ),
                  ),
                  
                  SizedBox(width: 16),
                  
                  // Contenedor para la información del producto (derecha)
                  Expanded(
                    flex: 2,
                    child: ProductInfoSection(
                      product: product, 
                      controller: controller,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
           // Productos relacionados
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(
        color: GerenaColors.primaryColor.withOpacity(0.3),
        thickness: 1,
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Icon(Icons.sync_alt, color: GerenaColors.primaryColor),
          const SizedBox(width: 8),
          Text(
            'PRODUCTOS RELACIONADOS',
            style: TextStyle(
              color: GerenaColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ],
  ),
),
            const SizedBox(height: 8),
            
            // Carousel para productos relacionados
            RelatedProductsCarousel(),
          ],
        ),
      ),
    );
  }
}

class ProductImageSection extends StatelessWidget {
  final Map<String, String> product;
  final ProductDetailController controller;
  
  const ProductImageSection({
    Key? key,
    required this.product,
    required this.controller,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550, // Ajustar altura para que coincida aproximadamente con la sección de info
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ProductImageCarousel(controller: controller),
      ),
    );
  }
}

class ProductImageCarousel extends StatelessWidget {
  final ProductDetailController controller;
  
  const ProductImageCarousel({
    Key? key,
    required this.controller,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Carrusel de imágenes
        Obx(() => CarouselSlider(
          carouselController: controller.carouselController,
          options: CarouselOptions(
            height: 550, // Ajustar altura para ocupar todo el container padre
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: true,
            onPageChanged: controller.onImageChanged,
          ),
          items: controller.productImages.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/tienda-producto.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      imagePath,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        )),
        
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: GerenaColors.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: GerenaColors.surfaceColor,
                size: 18,
              ),
            ),
            onPressed: controller.previousImage,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: GerenaColors.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: GerenaColors.surfaceColor,
                size: 18,
              ),
            ),
            onPressed: controller.nextImage,
          ),
        ),
        
        // Indicadores
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: controller.productImages.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.currentImageIndex.value == entry.key
                      ? GerenaColors.secondaryColor
                      : Colors.grey.withOpacity(0.5),
                ),
              );
            }).toList(),
          )),
        ),
      ],
    );
  }
}

class ProductInfoSection extends StatelessWidget {
  final Map<String, String> product;
  final ProductDetailController controller;
  
  const ProductInfoSection({
    Key? key,
    required this.product,
    required this.controller,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categoría
          Text(
            'Categoría: Toxina Botulínica Tipo A',
            style: TextStyle(
              color: GerenaColors.textSecondaryColor,
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Título del producto
          Text(
            product['name'] ?? 'MD COLAGENASA',
            style: TextStyle(
              color: GerenaColors.textPrimaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Precio
          Text(
            product['price'] ?? '1,000.00 MXN',
            style: TextStyle(
              color: GerenaColors.textPrimaryColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Descuento
          Text(
            '4 X \$8,400.00 MXN',
            style: TextStyle(
              color: GerenaColors.accentColor,
              fontSize: 16,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Línea divisora
          Divider(),
          
          const SizedBox(height: 8),
          
          // Descripción
          Text(
            'Descripción:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'La Toxina Botulínica tipo A LinuraseTM se reconstituye en solución fisiológica estéril al 0.9% NaCl (cloruro de sodio) para generar una solución inyectable; el procedimiento debe llevarse a cabo en condiciones de asepsia y antisepsia.',
            style: TextStyle(
              fontSize: 14,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Características
          Text(
            'Características:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Vial de 100 Unidades\nMayor potencia, bloqueo musculas más eficaz.\nDuración hasta por más de 5 meses',
            style: TextStyle(
              fontSize: 14,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Línea divisora
          Divider(),
          
          const SizedBox(height: 8),
          
          // Enlaces
          InkWell(
            onTap: () {
              // Acción para términos y condiciones
            },
            child: Row(
              children: [
                Icon(Icons.description_outlined, size: 16, color: GerenaColors.primaryColor),
                const SizedBox(width: 4),
                Text(
                  'Consulta términos y condiciones de la venta',
                  style: TextStyle(
                    color: GerenaColors.primaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          InkWell(
            onTap: () {
              // Acción para descargar ficha técnica
            },
            child: Row(
              children: [
                Icon(Icons.download_outlined, size: 16, color: GerenaColors.primaryColor),
                const SizedBox(width: 4),
                Text(
                  'Descargar Ficha Técnica',
                  style: TextStyle(
                    color: GerenaColors.primaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Botón de añadir al carrito
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => controller.addToCart(product),
              icon: Icon(Icons.shopping_cart),
              label: Text('AÑADIR AL CARRITO'),
              style: ElevatedButton.styleFrom(
                backgroundColor: GerenaColors.secondaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Botón de favorito
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: GerenaColors.primaryColor),
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_border),
                color: GerenaColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RelatedProductsCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Usar el controlador existente
    final controller = Get.find<ProductDetailController>();
    
    return Container(
      height: 250,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Obx(() => CarouselSlider(
            carouselController: controller.relatedCarouselController,
            options: CarouselOptions(
              height: 250,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              autoPlay: false,
              onPageChanged: controller.onRelatedPageChanged,
            ),
            items: controller.relatedProductPages.map((pageItems) {
              return Builder(
                builder: (BuildContext context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pageItems.map((product) {
                      return Expanded(
                        child: RelatedProductCard(
                          name: product['name']!,
                          price: product['price']!,
                          originalPrice: product['originalPrice']!,
                          label: product['label']!,
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            }).toList(),
          )),
          
          // Flechas de navegación
          Obx(() {
            if (controller.relatedProductPages.length > 1) {
              return Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: GerenaColors.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: GerenaColors.surfaceColor,
                          size: 16,
                        ),
                      ),
                      onPressed: controller.previousRelatedPage,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: GerenaColors.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: GerenaColors.surfaceColor,
                          size: 16,
                        ),
                      ),
                      onPressed: controller.nextRelatedPage,
                    ),
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          })
        ],
      ),
    );
  }
}

class RelatedProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String originalPrice;
  final String label;
  
  const RelatedProductCard({
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.label,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
          // Imagen
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/tienda-producto.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/productoenventa.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          
          // Información del producto
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
                
                Text(
                  originalPrice,
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    color: GerenaColors.secondaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}