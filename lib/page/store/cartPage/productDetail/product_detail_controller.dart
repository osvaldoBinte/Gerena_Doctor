import 'package:get/get.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
class ProductDetailController extends GetxController {
  final carouselController = CarouselSliderController();
  final currentImageIndex = 0.obs;
  
  final relatedCarouselController = CarouselSliderController();
  final currentRelatedPage = 0.obs;
  
  final productImages = <String>[
    'assets/productoenventa.png',
    'assets/productoenventa.png',
    'assets/productoenventa.png',
    'assets/productoenventa.png',
  ].obs;
  
  final relatedProducts = [
    {'name': 'INNOTOX', 'price': '₱3,000.00 MXN', 'originalPrice': '₱3,100.00 MXN', 'label': 'EN PROMOCIÓN'},
    {'name': 'NABOTA', 'price': '₱3,000.00 MXN', 'originalPrice': '₱3,100.00 MXN', 'label': 'EN PROMOCIÓN'},
    {'name': 'DERMA WRINKLES', 'price': '₱3,000.00 MXN', 'originalPrice': '₱3,100.00 MXN', 'label': 'EN PROMOCIÓN'},
    {'name': 'ZADE SKIN PLUS+', 'price': '₱3,000.00 MXN', 'originalPrice': '₱3,100.00 MXN', 'label': 'EN PROMOCIÓN'},
    {'name': 'CELOSOME SOFT', 'price': '₱3,000.00 MXN', 'originalPrice': '₱3,100.00 MXN', 'label': 'EN PROMOCIÓN'},
    {'name': 'GLAM FILL', 'price': '₱3,000.00 MXN', 'originalPrice': '₱3,100.00 MXN', 'label': 'EN PROMOCIÓN'},
    {'name': 'JADE GAIN', 'price': '₱3,000.00 MXN', 'originalPrice': '₱3,100.00 MXN', 'label': 'EN PROMOCIÓN'},
    {'name': 'MD COLAGENASA', 'price': '₱3,000.00 MXN', 'originalPrice': '₱3,100.00 MXN', 'label': 'EN PROMOCIÓN'},
  ].obs;
  
  final relatedProductPages = <List<Map<String, String>>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    _initRelatedProductPages();
  }
  
  void nextImage() {
    carouselController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
  
  void previousImage() {
    carouselController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
  
  void nextRelatedPage() {
    relatedCarouselController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
  
  void previousRelatedPage() {
    relatedCarouselController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
  
  void onImageChanged(int index, CarouselPageChangedReason reason) {
    currentImageIndex.value = index;
  }
  
  void onRelatedPageChanged(int index, CarouselPageChangedReason reason) {
    currentRelatedPage.value = index;
  }
  
  void _initRelatedProductPages() {
    final int itemsPerPage = 4;
    relatedProductPages.clear();
    
    for (int i = 0; i < relatedProducts.length; i += itemsPerPage) {
      relatedProductPages.add(
        relatedProducts.sublist(
          i, 
          i + itemsPerPage > relatedProducts.length 
              ? relatedProducts.length 
              : i + itemsPerPage
        )
      );
    }
  }
  
  void addToCart(Map<String, String> product) {
    Get.snackbar(
      'Producto añadido',
      '${product['name']} ha sido añadido al carrito',
      backgroundColor: Get.theme.colorScheme.secondary,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }
}