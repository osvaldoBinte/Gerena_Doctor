
  import 'package:flutter/material.dart';
import 'package:gerena/features/marketplace/presentation/page/wishlist/Wishlist_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

  final WishlistController controller = Get.put(WishlistController());
Widget simpleCounter() {
    int count = 6;
  
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => print('Decrementar'),
          child: Text(
            '−',
            style: GoogleFonts.rubik(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$count',
            style: GoogleFonts.rubik(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        GestureDetector(
          onTap: () => print('Incrementar'),
          child: Text(
            '+',
            style: GoogleFonts.rubik(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
