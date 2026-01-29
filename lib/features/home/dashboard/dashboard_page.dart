import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/modal_agregar_cita.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/modal_cancelar_cita.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/modal_completar_cita.dart';
import 'package:gerena/features/appointment/presentation/page/calendar/calendar_controller.dart';
import 'package:gerena/features/appointment/presentation/page/perfil/PatientProfileScreen.dart';
import 'package:gerena/features/doctors/presentation/page/portafolio/doctor_profile_page.dart';
import 'package:gerena/features/subscription/presentation/page/membresia/membresia.dart';
import 'package:gerena/features/home/dashboard/dashboard_controller.dart';
import 'package:gerena/features/home/dashboard/widget/appbar/gerena_app_bar_controller.dart';
import 'package:gerena/features/banners/presentation/page/noticias/news_feed_widget.dart';
import 'package:gerena/features/home/dashboard/widget/preguntasFrecuentes/preguntas_frecuentes.dart';
import 'package:gerena/features/home/dashboard/widget/sugerencia/sugerencia.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/desktop/Profile_doctor.dart';
import 'package:get/get.dart';
import 'package:gerena/features/appointment/presentation/page/calendar/calendar_widget.dart';
import 'package:gerena/features/home/dashboard/widget/appbar/gerena_app_bar.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/sidebar_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DashboardPage extends StatelessWidget {
  final bool showAppBar;

  const DashboardPage({
    Key? key,
    this.showAppBar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (arguments['showDoctorProfile'] == true) {
          controller.showDoctorProfile();
          print('Perfil del doctor mostrado via argumentos');
        } else if (arguments['showUserProfile'] == true) {
          controller.showUserProfile();
          print('Perfil del usuario mostrado via argumentos');
        } else if (arguments['showMainView'] == true) {
          controller.showMainView();
          print('Vista principal mostrada via argumentos');
        }
      });
    }
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorfondo,
      appBar: showAppBar
          ? PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: GerenaAppBar(),
            )
          : null,
      drawer: const SidebarWidget(),
      body: Container(
        child: showAppBar
            ? Row(
                children: [
                  if (showAppBar) const SidebarWidget(),
                  Expanded(
                    child: _buildDashboardContent(controller),
                  ),
                ],
              )
            : _buildDashboardContent(controller),
      ),
    );
  }

  Widget _buildDashboardContent(DashboardController controller) {
    return Container(
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColorfondo,
      ),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: controller.isCalendarFullScreen.value
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildCalendarFullScreen(controller),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildMainContent(controller),
                      ),
              ),
            ],
          )),
    );
  }


  Widget _buildMainContent(DashboardController controller) {
    switch (controller.currentView.value) {
      case 'doctor_profile':
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildBackButton(controller),
              const SizedBox(height: 16),
              _buildDoctorProfileContent(),
            ],
          ),
        );
      case 'user_profile':
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildUserProfileContent(),
            ],
          ),
        );
      case 'membresia':
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildBackButtonMembresia(controller),
              const SizedBox(height: 16),
              _buildMembresia(),
            ],
          ),
        );
      case 'PreguntasFrecuentes':
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildBackButtonSugerencia(controller),
              const SizedBox(height: 16),
              _buildPreguntasFrecuentesContent(),
            ],
          ),
        );
      case 'sugerencia':
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildBackButtonSugerencia(controller),
              const SizedBox(height: 16),
              _buildSugerencia(),
            ],
          ),
        );
      case 'patient_profile':
        return _buildPatientProfileContent(controller);
      case 'appointments':
        return _buildCalendarOrAppointmentsSection(controller);
      default:
        return _buildRowWithSelectiveScroll(controller);
    }
  }

  Widget _buildPatientProfileContent(DashboardController controller) {
    final calendarController = Get.find<CalendarControllerGetx>();
    final appointment = controller.selectedAppointmentForProfile.value;

    if (appointment == null) {
      return Center(
        child: Text('No se encontró la cita'),
      );
    }

    int? appointmentId;
    if (appointment.id != null) {
      if (appointment.id is int) {
        appointmentId = appointment.id as int;
      } else if (appointment.id is String) {
        appointmentId = int.tryParse(appointment.id.toString());
      } else {
        appointmentId = int.tryParse(appointment.id.toString());
      }
    }

    if (appointmentId == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: GerenaColors.errorColor,
            ),
            SizedBox(height: 16),
            Text(
              'ID de cita inválido',
              style: TextStyle(
                fontSize: 16,
                color: GerenaColors.textPrimaryColor,
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => controller.hidePatientProfileView(),
              child: Text('Volver'),
            ),
          ],
        ),
      );
    }

    final appointmentEntity =
        calendarController.getAppointmentEntity(appointmentId);

    if (appointmentEntity == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 60,
              color: GerenaColors.textSecondaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'No se encontró la información del paciente',
              style: TextStyle(
                fontSize: 16,
                color: GerenaColors.textPrimaryColor,
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => controller.hidePatientProfileView(),
              child: Text('Volver'),
            ),
          ],
        ),
      );
    }

    return PatientProfileScreen(
      appointmentEntity: appointmentEntity,
      onClose: () {
        controller.hidePatientProfileView();
      },
    );
  }

  Widget _buildRowWithSelectiveScroll(DashboardController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: const NewsFeedWidget(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: _buildCalendarOrAppointmentsSection(controller),
        ),
      ],
    );
  }

  Widget _buildDoctorProfileContent() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 1200,
      ),
      child: const DoctorProfileContent(),
    );
  }

  Widget _buildUserProfileContent() {
    return Container(
      child: const UserProfileContent(),
    );
  }

  Widget _buildPreguntasFrecuentesContent() {
    return Container(
      child: const PreguntasFrecuentes(),
    );
  }

  Widget _buildMembresia() {
    return Container(
      child: const Membresia(),
    );
  }

  Widget _buildSugerencia() {
    return Container(
      child: const Sugerencia(),
    );
  }

  Widget _buildBackButtonMembresia(DashboardController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: Row(
        children: [
          const Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Membresías',
                    style: TextStyle(
                      color: GerenaColors.textPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Accede a unicas promociones y descuentos ',
                    style: TextStyle(color: GerenaColors.textSecondaryColor),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/close.png',
              color: GerenaColors.textSecondaryColor,
              width: 20,
              height: 20,
            ),
            onPressed: () => controller.showUserProfile(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButtonSugerencia(DashboardController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: Row(
        children: [
          Expanded(child: Container()),
          IconButton(
            icon: Image.asset(
              'assets/icons/close.png',
              color: GerenaColors.textSecondaryColor,
              width: 20,
              height: 20,
            ),
            onPressed: () => controller.showUserProfile(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(DashboardController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'La información presentada en los siguientes apartados será mostrada según sea llenada en la aplicación para clientes de Gerena.',
              style: TextStyle(color: GerenaColors.textSecondaryColor),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/close.png',
              color: GerenaColors.textSecondaryColor,
              width: 20,
              height: 20,
            ),
            onPressed: () => controller.showMainView(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarOrAppointmentsSection(DashboardController controller) {
    // SIN Obx aquí - ya está envuelto por el Obx de _buildDashboardContent
    if (controller.currentView.value == 'appointments') {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 67,
                  decoration: BoxDecoration(
                    color: GerenaColors.textPrimaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _getDayAbbreviation(controller.selectedDate.value!),
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          '${controller.selectedDate.value!.day}',
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Spacer(),
                IconButton(
                  icon: Image.asset(
                    'assets/icons/close.png',
                    width: 20,
                    height: 20,
                  ),
                  onPressed: () => controller.showCalendar(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildMedicalAppointmentsContent(
            controller.selectedDate.value!,
            controller.selectedAppointments,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: GerenaColors.textPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: GerenaColors.textLightColor,
                    size: 40,
                  ),
                  onPressed: () {
                    ModalAgregarCita.show(

                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return _buildCalendarAndAppointments(controller);
    }
  }

  String _getDayAbbreviation(DateTime date) {
    final weekdays = ['LUN', 'MAR', 'MIE', 'JUE', 'VIE', 'SAB', 'DOM'];
    return weekdays[date.weekday - 1];
  }

  Widget _buildMedicalAppointmentsContent(
      DateTime selectedDate, List<dynamic> appointments) {
    return Container(
      child: appointments.isEmpty
          ? _buildEmptyAppointmentsState(selectedDate)
          : Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildAppointmentCardFromData(appointment),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyAppointmentsState(DateTime selectedDate) {
    final formattedDate = _formatDate(selectedDate);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay citas programadas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'para el $formattedDate',
            style: TextStyle(
              fontSize: 14,
              color: GerenaColors.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Agregar Cita'),
            style: ElevatedButton.styleFrom(
              backgroundColor: GerenaColors.secondaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
Widget _buildAppointmentCardFromData(Appointment appointment) {
  final hour = appointment.startTime.hour;
  final minute = appointment.startTime.minute;
  final period = hour < 12 ? 'A.M.' : 'P.M.';
  final formattedHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  final formattedTime =
      '$formattedHour:${minute.toString().padLeft(2, '0')} $period';

  String patientName = appointment.subject;
  String procedure = appointment.notes ?? 'Procedimiento no especificado';
  String additionalInfo = appointment.location ?? 'Seguimiento';

  if (procedure.startsWith('Procedimiento: ')) {
    procedure = procedure.replaceFirst('Procedimiento: ', '');
  }

  int appointmentId = 0;
  if (appointment.id != null) {
    if (appointment.id is int) {
      appointmentId = appointment.id as int;
    } else if (appointment.id is String) {
      appointmentId = int.tryParse(appointment.id.toString()) ?? 0;
    } else {
      appointmentId = int.tryParse(appointment.id.toString()) ?? 0;
    }
  }

  // AÑADIDO: Obtener el status de la cita
  final calendarController = Get.find<CalendarControllerGetx>();
  final appointmentEntity = calendarController.getAppointmentEntity(appointmentId);
  final status = appointmentEntity?.status ?? '';
  final isCompletada = status.toLowerCase() == 'completada';

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.transparent,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: GerenaColors.mediumBorderRadius,
              boxShadow: [GerenaColors.lightShadow],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          child: _buildDefaultAvatar(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre Del Paciente',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: GerenaColors.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            patientName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GerenaColors.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Procedimiento',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: GerenaColors.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            procedure,
                            style: const TextStyle(
                              fontSize: 14,
                              color: GerenaColors.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Información Adicional',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: GerenaColors.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            additionalInfo,
                            style: const TextStyle(
                              fontSize: 16,
                              color: GerenaColors.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          formattedTime,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: GerenaColors.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildActionButton(
              icon: Icons.remove_red_eye_rounded,
              color: GerenaColors.primaryColor,
              onPressed: () {
                final controller = Get.find<DashboardController>();
                controller.showPatientProfileView(appointment);
              },
            ),
            // MODIFICADO: Solo mostrar estos botones si NO está completada
            if (!isCompletada) ...[
              const SizedBox(height: 12),
              _buildActionButton(
                icon: Icons.check_circle,
                color: GerenaColors.successColor,
                onPressed: () {
                  ModalCompletarCita.show(appointmentId);
                },
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                icon: Icons.cancel,
                color: GerenaColors.errorColor,
                onPressed: () {
                  ModalCancelarCita.show(appointmentId);
                },
              ),
            ],
          ],
        ),
      ],
    ),
  );
}
  Widget _buildDefaultAvatar() {
    return Container(
      child: Image.asset(
        'assets/icons/FOTOGRAFIA.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildActionButton({
    String? assetPath,
    IconData? icon,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: icon != null
                ? Icon(
                    icon,
                    color: color ?? GerenaColors.textSecondaryColor,
                    size: 24,
                  )
                : Image.asset(
                    assetPath!,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    color: color,
                  ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildCalendarFullScreen(DashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              icon: Icon(Icons.arrow_back, color: GerenaColors.accentColor),
              label: Text(
                'Volver a la vista normal',
                style: TextStyle(color: GerenaColors.accentColor),
              ),
              onPressed: controller.exitCalendarFullScreen,
            ),
          ],
        ),
        const SizedBox(height: 8),
        CalendarWidget(
          onDateSelected: controller.onDateSelected,
        ),
      ],
    );
  }

  Widget _buildCalendarAndAppointments(DashboardController controller) {
    return CalendarWidget(
      onDateSelected: controller.onDateSelected,
    );
  }
}