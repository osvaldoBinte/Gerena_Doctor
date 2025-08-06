import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/simple_counter.dart';
import 'package:gerena/page/dashboard/widget/appbar/gerena_app_bar.dart';
import 'package:gerena/page/dashboard/widget/appbar/gerena_app_bar_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPageContent extends StatelessWidget {
  final VoidCallback onBackPressed;
  
  CartPageContent({Key? key, required this.onBackPressed}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorfondo,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 10000),
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        _buildCartItem(
                          "RED VOLUMEN", 
                          "Relleno dérmico con una de las tecnologías más avanzadas. Tiene efecto volumen debido a su estructura reticular homogénea a la profundidad de la dermis, lo que permite continuidad en los resultados estéticos de RED.",
                          "assets/productoenventa.png",
                          "1,500.00 MXN",
                          hasDiscount: true,
                          originalPrice: "2,000.00 MXN",
                        ),
                        _buildCartItem(
                          "CELOSOME STRONG", 
                          "Bioregenerador de segunda generación basado en el rejuvenecimiento de la piel mediante perfecta unificación y replicación. Contiene la tecnología en alta concentración de células dérmicas.",
                          "assets/productoenventa.png",
                          "1,000.00 MXN",
                        ),
                        _buildCartItem(
                          "LIPORASE", 
                          "La inyección de ácido glicólico para disolver las células adiposas y grasas mediante la fusión de las membranas fosfolipídicas. Liporase, también conocido como PPAR, proporciona un resultado visible cuando se administra en las estructuras adiposas para lograr un mejor contorno facial.",
                          "assets/productoenventa.png",
                          "2,000.00 MXN",
                        ),
                        _buildCartItem(
                          "CÁNULAS", 
                          "",
                          "assets/productoenventa.png",
                          "900.00 MXN",
                        ),
                        const Divider(),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    _buildSection("DIRECCIÓN DE ENTREGA"),
                    
                    const SizedBox(height: 15),
                    
                    _buildSelectedAddress(
                      "Juan Pedro González Pérez +52 3333303333",
                      "Col. Providencia, Av. Lorem ipsum #3050, Guadalajara, Jalisco, México",
                      isSelected: true,
                    ),
                    
                    const SizedBox(height: 10),
                    
                    _buildAddressSelector(
                      "En sucursal",
                      "Col. Lorem ipsum Av. Lorem ipsum #3050, Guadalajara, Jalisco, México",
                    ),
                    
                    const SizedBox(height: 30),
                    
                    _buildSection("MÉTODO DE PAGO"),
                    
                    const SizedBox(height: 15),
                    
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildPaymentMethod("5545 3******** 9905"),
                    ),
                    
                    const SizedBox(height: 30),
                    Divider(color: GerenaColors.textTertiaryColor),
                    const SizedBox(height: 30),

                    _buildSection("RESUMEN"),
                    
                    const SizedBox(height: 15),
                    
                    _buildSummaryItem("Subtotal", "15,850.00 MXN"),
                    Divider(color: GerenaColors.textTertiaryColor),
                    _buildSummaryItem("Descuentos y promociones", "-1,000.00 MXN"),
                    Divider(color: GerenaColors.textTertiaryColor),
                    _buildSummaryItem("*IVA", "2,376.00 MXN"),
                    Divider(color: GerenaColors.textTertiaryColor),
                    _buildSummaryItem("Gastos de envío", "250.00 MXN"),
                    Divider(color: GerenaColors.textTertiaryColor),
                    _buildSummaryItem("Puntos acumulados", "+280.00 MXN"),
                    
                    const Divider(height: 30),
                    
                    _buildTotalRow("TOTAL:", "17,195.00 MXN"),
                    
                    const SizedBox(height: 100),
                  
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GerenaColors.secondaryColor,
                            foregroundColor: GerenaColors.cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                          ),
                          child: Text(
                            "CONFIRMAR COMPRA",
                            style: GoogleFonts.rubik(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(String title, String description, String imagePath, String price, {bool hasDiscount = false, String? originalPrice}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            imagePath,
            width: 80,
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 15),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: GerenaColors.primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              if (description.isNotEmpty)
                Text(
                  description,
                  style: GoogleFonts.rubik(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 5),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasDiscount && originalPrice != null)
                        Row(
                          children: [
                            Text(
                              originalPrice,
                              style: GoogleFonts.rubik(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              price,
                              style: GoogleFonts.rubik(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          price,
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: GerenaColors.primaryColor,
                          ),
                        ),
                    ],
                  ),
                  
                  simpleCounter(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title) {
    return Text(
      title,
      style: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: GerenaColors.textTertiaryColor,
      ),
    );
  }
  
  Widget _buildSelectedAddress(String name, String address, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          if (isSelected)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                'assets/icons/check.png',
                width: 30,
                height: 30,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  address,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    color: GerenaColors.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Image.asset(
              'assets/icons/edit.png',
              width: 30,
              height: 30,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddressSelector(String title, String address) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 70),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
                Text(
                  address,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    color: GerenaColors.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String number) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/visa.png',
            width: 30,
            height: 30,
          ),
          
          const SizedBox(width: 10),
          
          Text(
            "$number",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w500,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          
          const SizedBox(width: 15),
          
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryItem(String label, String value) {
    final Color valueColor = GerenaColors.textTertiaryColor;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.rubik(
              color: GerenaColors.textTertiaryColor,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 4, 
          child: Container(),
        ),
        Text(
          label,
          style: GoogleFonts.rubik(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: GerenaColors.textTertiaryColor,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Text(
          value,
          style: GoogleFonts.rubik(
            fontSize: 18,
            color: GerenaColors.textTertiaryColor,
          ),
        ),
      ],
    );
  }
}