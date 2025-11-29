import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgts.dart';
import 'package:gerena/features/appointment/presentation/page/calendar/calendar_controller.dart';
import 'package:gerena/features/appointment/presentation/page/perfil/PatientProfileScreen.dart';
import 'package:gerena/features/banners/presentation/page/banners/banners_list_widget.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/controller_perfil_configuration.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:gerena/features/stories/presentation/page/MyStoryRingWidget.dart';
import 'package:gerena/features/stories/presentation/page/story_controller.dart';
import 'package:gerena/features/stories/presentation/page/story_modal_widget.dart';
import 'package:gerena/features/stories/presentation/page/story_ring_widget.dart';
import 'package:gerena/movil/homePage/PostController/post_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageMovil extends StatefulWidget {
  const HomePageMovil({Key? key}) : super(key: key);

  @override
  State<HomePageMovil> createState() => _GerenaFeedScreenState();
}

class _GerenaFeedScreenState extends State<HomePageMovil> {
  final CalendarControllerGetx calendarController =
      Get.find<CalendarControllerGetx>();
  
  final PrefilDortorController doctorController = Get.find<PrefilDortorController>();
  final ControllerPerfilConfiguration profileController = Get.put(ControllerPerfilConfiguration());
  
  // Agrega esta línea
  final StoryController storyController = Get.find<StoryController>();

  @override
  void initState() {
    super.initState();
    final fechaInicial = DateTime(2025, 9, 1);
    calendarController.loadAppointmentsForDate(fechaInicial);
  }

  @override
  Widget build(BuildContext context) {
    final double availableHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        kBottomNavigationBarHeight;

    List<Widget> allItems = [
      Container(
        height: availableHeight,
        child: Column(
          children: [
            // Sección de historias
            Container(
  height: 100,
  color: GerenaColors.backgroundColorFondo,
  child: Obx(() {
    if (storyController.isLoading.value && storyController.allStories.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final totalStories = storyController.allStories.length;
    
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: totalStories + 1, 
      itemBuilder: (context, index) {
        if (index == 0) {
          return MyStoryRingWidget(
            size: 80,
            onAddStory: () {
              print("Navegar a crear historia");
              // Get.to(() => CreateStoryScreen());
            },
          );
        }

        return Container(
          margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
          child: StoryRingWidget(
            index: index - 1,
            size: 80,
          ),
        );
      },
    );
  }),
),
            
            // Resto del contenido
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: GerenaColors.paddingMedium),
                    _buildCitasSection(),
                    SizedBox(height: GerenaColors.paddingMedium),
                    BannersListWidget(
                      height: 200,
                      maxBanners: 2,
                    ),
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
          ],
        ),
      ),
      body: Obx(() {
        if (profileController.showPatientProfile.value) {
          return PatientProfileScreen(
            appointment: profileController.selectedAppointment.value,
            onClose: () {
              profileController.hidePatientProfileView();
            },
          );
        }
        
        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: allItems.length,
          itemBuilder: (context, index) {
            return allItems[index];
          },
          physics: const BouncingScrollPhysics(),
        );
      }),
    );
  }

  // Widget para el botón de "Agregar mi historia"
  Widget _buildAddStoryButton() {
    return Container(
      margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              print("Agregar mi historia");
              // Aquí puedes agregar la funcionalidad para crear una historia
            },
            child: Obx(() {
              final doctor = doctorController.doctorProfile.value;
              
           Widget imageWidget;

if (doctorController.isLoading.value) {
  imageWidget = Container(
    color: GerenaColors.backgroundColorfondo,
    child: const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    ),
  );
} else if (doctor?.foto != null && doctor!.foto!.isNotEmpty) {
  imageWidget = Image.network(
    doctor.foto!,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return _fallbackIcon();
    },
  );
} else {
  imageWidget = _fallbackIcon();
}

              
              return Stack(
                children: [
                  GerenaColors.createStoryRing(
                    child: imageWidget,
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
              );
            }),
          ),
        ],
      ),
    );
  }
  Widget _fallbackIcon() {
  return Container(
    color: GerenaColors.backgroundColorfondo,
    child: const Center(
      child: Icon(
        Icons.person,
        size: 50,
        color: Colors.grey,
      ),
    ),
  );
}

  Widget _buildCitasSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CITAS',
                style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: GerenaColors.textPrimaryColor,
                ),
              ),
              Obx(() => calendarController.isLoading.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: GerenaColors.primaryColor,
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.refresh, size: 20),
                      onPressed: () {
                        calendarController.loadAppointmentsForDate(
                          calendarController.focusedDate.value,
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    )),
            ],
          ),
          SizedBox(height: GerenaColors.paddingSmall),

        
          Obx(() {
         
            if (calendarController.isLoading.value &&
                calendarController.appointments.isEmpty) {
              return Container(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(
                    color: GerenaColors.primaryColor,
                  ),
                ),
              );
            }

           
            final upcomingAppointments = _getUpcomingAppointments();

     
            if (upcomingAppointments.isEmpty) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  color: GerenaColors.backgroundColor,
                  borderRadius: GerenaColors.mediumBorderRadius,
                  boxShadow: [GerenaColors.lightShadow],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 48,
                        color: GerenaColors.textSecondaryColor,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No tienes citas próximas',
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: GerenaColors.textSecondaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                         
                          print('Ir a crear cita');
                        },
                        child: Text(
                          'Agendar cita',
                          style: GoogleFonts.rubik(
                            fontSize: 13,
                            color: GerenaColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

          
            return Column(
              children: [
                Container(
                  height: 200,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.85),
                    itemCount: upcomingAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = upcomingAppointments[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: _buildCitaCard(appointment),
                      );
                    },
                  ),
                ),
                if (upcomingAppointments.length > 1) ...[
                  SizedBox(height: 20),
                  _buildPageIndicators(upcomingAppointments.length),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  List<dynamic> _getUpcomingAppointments() {
    final allAppointments = calendarController.appointments.toList();

    if (allAppointments.isEmpty) {
      return [];
    }

    allAppointments.sort((a, b) => a.startTime.compareTo(b.startTime));

    return allAppointments.take(5).toList();
  }

  Widget _buildCitaCard(dynamic appointment) {
    final String formattedTime = _formatTime(appointment.startTime);
    final String formattedDate = _formatDate(appointment.startTime);


    final String doctorName = appointment.subject ?? 'Sin nombre';
    final String appointmentType = appointment.location ?? 'Cita general';
    final String treatment = appointment.notes ?? 'Sin descripción';

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
                        child: Container(
                          decoration: BoxDecoration(
                            color: GerenaColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: GerenaColors.textLightColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      formattedTime,
                      style: GoogleFonts.rubik(
                        fontSize: 13,
                        color: GerenaColors.textQuaternary,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      formattedDate,
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
                       profileController.showPatientProfileView(appointment);

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

  Widget _buildPageIndicators(int count) {
    if (count <= 1) return SizedBox.shrink();

    return Row(
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
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'P.M.' : 'A.M.';
    return '$hour:$minute $period';
  }

  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    return '$day/$month/$year';
  }

  void _navigateToAppointmentDetails(dynamic appointment) {
    print('Ver detalles de cita ID: ${appointment.id}');

    // Get.to(() => AppointmentDetailsPage(appointmentId: appointment.id));
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
