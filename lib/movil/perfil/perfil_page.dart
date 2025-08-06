import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:gerena/page/dashboard/widget/estatusdepedido/estatus_de_pedido.dart';
import 'package:gerena/page/dashboard/widget/estatusdepedido/widgets_status_pedido.dart'; 
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; 

class DoctorProfilePage extends StatefulWidget {
  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
      final StartController controller = Get.find<StartController>();

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: GerenaColors.backgroundColorFondo,
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: AppBar(
        backgroundColor: GerenaColors.backgroundColorFondo,
        elevation: 4,
        shadowColor: GerenaColors.shadowColor,
      ),
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildDoctorHeader(),
          ),
          SizedBox(height:  GerenaColors.paddingMedium),
           _buildWishlistButton(),
          SizedBox(height:  GerenaColors.paddingMedium),
          StatusCardWidget(),
          SizedBox(height: GerenaColors.paddingMedium,),
          Container(
                    padding: const EdgeInsets.all(16),
                   
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recompensas:',
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '250 puntos',
                              style: GoogleFonts.rubik(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: GerenaColors.paddingMedium,),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ejecutivo asignado:',
                                  style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: GerenaColors.textPrimaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Carolina Fernández',
                                  style: GoogleFonts.rubik(
                                    fontSize: 13,
                                    color: GerenaColors.textPrimaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Lun. - Sáb. 9:00 a.m. a 6:00 p.m.',
                                  style: GoogleFonts.rubik(
                                    fontSize: 11,
                                    color: GerenaColors.textPrimaryColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          
                          
                          GerenaColors.widgetButton(
                            onPressed: () {
                              print('Botón contactar presionado');
                            },
                            text: 'CONTACTAR',
                            showShadow: false,
                            borderRadius: 20,
                          ),
                        ],
                      ),
                    ),
 Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child:Row(
  children: [
   
    Expanded(
      child: TextField(
        style: GoogleFonts.rubik(
          fontSize: 16,
          color:  GerenaColors.colorinput,
        ),
        decoration: InputDecoration(
          hintStyle: GoogleFonts.rubik(
            color: GerenaColors.colorinput,
            fontSize: 16,
          ),
          filled: true,
          fillColor: GerenaColors.backgroundColorfondo,
     
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 9,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: GerenaColors.colorinput),
          ),
          isDense: true,
        ),
      ),
    ),
    const SizedBox(width: 16), 

    GerenaColors.widgetButton(
      onPressed: () {
        print('Botón agregar presionado');
      },
      text: 'AGREGAR',
      showShadow: false,
      borderRadius: 20,
    ),
    
    
  ],
)
                    )


        ],
      ),
    ),
  );
}

  Widget _buildDoctorHeader() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: GerenaColors.cardDecoration,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                 Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
                children: [
  Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/perfil.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            SizedBox(height: GerenaColors.paddingExtraLarge),
             GerenaColors.createStarRating(rating: 5),
                       const SizedBox(width: 4),
                      Text(
                        '404 reseñas',
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: GerenaColors.primaryColor,
                        ),
                      ),
            ],
              ),
            const SizedBox(height: GerenaColors.paddingSmall),
                       Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Dr. Juan González',
                              style: GoogleFonts.rubik(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: GerenaColors.textPrimaryColor,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            'Cirujano estético',
                            style: GoogleFonts.rubik(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GerenaColors.textDarkColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                          'Ubicación: ',
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: GerenaColors.textTertiaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                            SizedBox(height: GerenaColors.paddingSmall),
                          Text(
                        'Clínica estética Gerena, Col. Providencia, Av. Atenas #3050, Guadalajara, Jalisco, México.',
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: GerenaColors.textTertiaryColor,
                        ),
                      ),
                              SizedBox(height: GerenaColors.paddingLarge),
                                SizedBox(height: GerenaColors.paddingSmall),
           Text('Cédula: 010101 10101 0101041',
                style: GoogleFonts.rubik(
                  fontSize: 14,
                  color: GerenaColors.textTertiaryColor,
                ),
              ),
                ],
              ),
            ),
          ),
          ],
        ),
                           SizedBox(height: GerenaColors.paddingMedium),
         Padding(padding: EdgeInsets.symmetric(horizontal: 10),
         child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             GerenaColors.widgetButton(
              showShadow: false,
              text: 'VER COMO PACIENTE',
              borderRadius: 30,
            ),
             GerenaColors.widgetButton(
              showShadow: false,
               text: 'EDITAR PERFIL',
               borderRadius: 30,
            ),
          ],
        ),
         ),
                   ],
                            ),
  );
}

    Widget _buildWishlistButton() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 13),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: GerenaColors.textLightColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Image.asset('assets/icons/calendar.png',
        height: 24,
        width: 24,),
                Expanded(
          child: Container(
            height: 1, // Grosor de la línea
            margin: const EdgeInsets.symmetric(horizontal: 12), // Espacio a los lados de la línea
            color: GerenaColors.textPrimaryColor, // Color de la línea
          ),
        ),
        Text(
          'CALENDARIO DE CITAS',
          style: GoogleFonts.rubik(
            color: GerenaColors.textPrimaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
}