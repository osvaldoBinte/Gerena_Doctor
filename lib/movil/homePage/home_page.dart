import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgts.dart';
import 'package:gerena/movil/homePage/PostController/post_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageMovil extends StatefulWidget {
  const HomePageMovil({Key? key}) : super(key: key);

  @override
  State<HomePageMovil> createState() => _GerenaFeedScreenState();
}

class _GerenaFeedScreenState extends State<HomePageMovil> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _buscarController = TextEditingController();
    final double availableHeight = MediaQuery.of(context).size.height -
                                   AppBar().preferredSize.height -
                                   kBottomNavigationBarHeight;

    String _getStoryUserImage(int index) {
      final List<String> userImages = [
        'assets/perfil.png',
        'assets/perfil.png',
        'assets/perfil.png',
        'assets/perfil.png',
        'assets/perfil.png',
        'assets/perfil.png'
      ];
      return userImages[index];
    }

    List<Widget> allItems = [
      Container(
        height: availableHeight,
        child: Column(
          children: [
            Container(
              height: 100,
              color: GerenaColors.backgroundColorFondo,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 6,
                itemBuilder: (context, index) {
                  if (index == 0) {
                   return Container(
                          margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Agregar mi historia");
                                },
                                child: Stack(
                                  children: [
                                    GerenaColors.createStoryRing(
                                      child: Image.asset(
                                        'assets/perfil.png',
                                        fit: BoxFit.cover,
                                      ),
                                      hasStory: false,
                                      size: 80,
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: SizedBox(
                                        width: 29,
                                        height: 29,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset(
                                            'assets/icons/aadHistory.png',
                                            fit: BoxFit.contain,
                                          ),
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

                  return Container(
                    margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                          },
                          child: GerenaColors.createStoryRing(
                            child: Image.asset(
                              _getStoryUserImage(index),
                              fit: BoxFit.cover,
                            ),
                            hasStory: true,
                            isViewed: false,
                            size: 80,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: GerenaColors.paddingMedium),
                    _buildCitasSection(),
                    SizedBox(height: GerenaColors.paddingMedium),
                   // _buildWebinarSection(),
                    SizedBox(height: GerenaColors.paddingMedium),
                   // _buildPromotionSection(),
                    SizedBox(height: GerenaColors.paddingMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorFondo,
      appBar: AppBar(
        backgroundColor: GerenaColors.backgroundColorFondo,
        elevation: 4,
        shadowColor: GerenaColors.shadowColor,
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
                onTap: () {
                },
              ),
            ),
          ],
        ),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: allItems.length,
        itemBuilder: (context, index) {
          return allItems[index];
        },
        physics: const BouncingScrollPhysics(),
      ),
    );
  }Widget _buildCitasSection() {
  final List<Map<String, String>> citas = [
    {
      'doctorName': 'Jessica Fernández Gutiérrez',
      'appointmentType': 'Primera Cita',
      'treatment': 'Toxina Botulínica En Tercio Superior Del Rostro',
      'time': '10:30 A.M.',
      'date': '19/04/2025',
      'profileImage': 'assets/doctor_profile.png',
    },
    {
      'doctorName': 'Dr. Carlos Mendoza',
      'appointmentType': 'Consulta Control',
      'treatment': 'Revisión de Rellenos Faciales',
      'time': '3:15 P.M.',
      'date': '22/04/2025',
      'profileImage': 'assets/doctor_profile2.png',
    },
    {
      'doctorName': 'Dra. Ana Martínez',
      'appointmentType': 'Procedimiento',
      'treatment': 'Aplicación de Bioestimuladores Faciales',
      'time': '11:00 A.M.',
      'date': '25/04/2025',
      'profileImage': 'assets/doctor_profile3.png',
    },
  ];

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CITAS',
          style: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
        SizedBox(height: GerenaColors.paddingSmall),
        
        Container(
          height: 200, 
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85), 
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: _buildCitaCard(
                  doctorName: cita['doctorName']!,
                  appointmentType: cita['appointmentType']!,
                  treatment: cita['treatment']!,
                  time: cita['time']!,
                  date: cita['date']!,
                  profileImage: cita['profileImage']!,
                ),
              );
            },
          ),
        ),
        
        SizedBox(height: 20),
        Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(
      width: 30,
      height: 5,
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [GerenaColors.mediumShadow],
      ),
    ),
    SizedBox(width: 6),
    Container(
      width: 80,
      height: 5,
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [GerenaColors.mediumShadow],
      ),
    ),
    SizedBox(width: 6),
    Container(
      width: 30,
      height: 5,
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [GerenaColors.mediumShadow],
      ),
    ),
     SizedBox(width: 6),
    Container(
      width: 20,
      height: 5,
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [GerenaColors.mediumShadow],
      ),
    ),
  ],
),
        const SizedBox(height: 16),

        buildWebinarCard(),
        const SizedBox(height: 16),
        buildPromoCard(),
      ],
    ),
  );
}
Widget _buildCitaCard({
  required String doctorName,
  required String appointmentType,
  required String treatment,
  required String time,
  required String date,
  required String profileImage,
}) {
  return Container(
    decoration: BoxDecoration(
      color: GerenaColors.backgroundColor,
      borderRadius: GerenaColors.mediumBorderRadius,
      boxShadow: [GerenaColors.lightShadow],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: GerenaColors.textPrimaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20),
                    Text(
                      appointmentType,
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: GerenaColors.textSecondaryColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      treatment,
                      style: GoogleFonts.rubik(
                        fontSize: 11,
                        color: GerenaColors.textTertiaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: 16),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [GerenaColors.lightShadow],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        profileImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: GerenaColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              color: GerenaColors.textLightColor,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                   Text(
                      time,
                      style: GoogleFonts.rubik(
                        fontSize: 13,
                        color: GerenaColors.textQuaternary,
                      ),
                    ),
                  SizedBox(height: 20),
                  Text(
                    date,
                    style: GoogleFonts.rubik(
                      fontSize: 10,
                      color: GerenaColors.textTertiaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          Center(
            child: IntrinsicWidth(
              child: GerenaColors.widgetButton(
                onPressed: () {
                },
                text: 'Ver Ficha',
                showShadow: false,
                borderRadius: 20,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildWebinarSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GerenaColors.primaryColor,
            GerenaColors.accentColor,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -10,
            bottom: -10,
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/webinar_doctor.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'WEBINAR',
                  style: GoogleFonts.rubik(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textLightColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'APLICACIONES AVANZADAS DE\nLA TOXINA BOTULÍNICA EN\nMEDICINA ESTÉTICA',
                  style: GoogleFonts.rubik(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: GerenaColors.textLightColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '25 DE ABRIL',
                  style: GoogleFonts.rubik(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textLightColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 120,
      decoration: BoxDecoration(
        color: GerenaColors.secondaryColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LINETOX',
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: GerenaColors.textLightColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$',
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: GerenaColors.textLightColor,
                        ),
                      ),
                      Text(
                        '1,500',
                        style: GoogleFonts.rubik(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: GerenaColors.textLightColor,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    '3 ml',
                    style: GoogleFonts.rubik(
                      fontSize: 10,
                      color: GerenaColors.textLightColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$',
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          color: GerenaColors.textLightColor,
                        ),
                      ),
                      Text(
                        '4,100',
                        style: GoogleFonts.rubik(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: GerenaColors.textLightColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/linetox_product.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: GerenaColors.textLightColor.withOpacity(0.2),
                      borderRadius: GerenaColors.smallBorderRadius,
                    ),
                    child: Icon(
                      Icons.medical_services,
                      color: GerenaColors.textLightColor,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}