import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/subscription/presentation/page/membresia/membresia.dart';
import 'package:google_fonts/google_fonts.dart';
class MembresiaPage extends StatelessWidget {
  const MembresiaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: GerenaColors.backgroundColorFondo,
          elevation: 4,
          shadowColor: GerenaColors.shadowColor,
        ),
      ),
      backgroundColor: GerenaColors.backgroundColorFondo,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          'Membresías',
                          style: GoogleFonts.rubik(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: GerenaColors.textTertiaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                         Text(
                          'Accede a únicas promociones y descuentos',
                          style:  GoogleFonts.rubik(
                            fontSize: 14,
                            color: GerenaColors.colorinput,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/icons/close.png',
                        width: 24,
                        height: 24,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Línea divisoria
            Container(
              height: 1,
              color: Colors.grey.shade200,
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const Membresia(), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
