import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/marketplace/presentation/page/shopping/shopping_cart_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingCartButton extends StatelessWidget {
  final double bottom;
  final double right;
  final double size;
  final String? cartRoute;

  const FloatingCartButton({
    Key? key,
    this.bottom = 30,
    this.right = 20,
    this.size = 60,
    this.cartRoute = '/cart',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ⭐ USAR Get.find() dentro del build para obtener la instancia correcta
    return Positioned(
      bottom: bottom,
      right: right,
      child: GetX<ShoppingCartController>( // ⭐ Usar GetX widget
        builder: (cartController) {
          final itemCount = cartController.totalItems;
          print('📊 FloatingCartButton - Total items: $itemCount');
          
          return GestureDetector(
            onTap: () {
  Get.toNamed(RoutesNames.shoppdingcart,);            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: GerenaColors.secondaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [GerenaColors.mediumShadow],
                  ),
                  child: Icon(
                    Icons.shopping_cart,
                    color: GerenaColors.textLightColor,
                    size: size * 0.47,
                  ),
                ),
                if (itemCount > 0)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: GerenaColors.errorColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      child: Center(
                        child: Text(
                          itemCount > 99 ? '99+' : '$itemCount',
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}