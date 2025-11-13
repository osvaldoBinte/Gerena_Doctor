import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/appointment/domain/entities/addappointment/add_appointment_entity.dart';
import 'package:gerena/features/appointment/domain/usecase/post_appointment_usecase.dart';
import 'package:gerena/features/doctors/domain/entities/doctoravailability/doctor_availability_entity.dart';
import 'package:gerena/features/doctors/domain/usecase/get_doctor_availability_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Clase para representar fechas con horarios disponibles
class AvailableDate {
  final DateTime date;
  final String diaNombre;
  final List<TimeSlot> timeSlots;

  AvailableDate({
    required this.date,
    required this.diaNombre,
    required this.timeSlots,
  });

  String get fecha => DateFormat('dd/MM/yyyy').format(date);
}

// Clase para representar un horario disponible
class TimeSlot {
  final String hora;
  final DateTime dateTime;

  TimeSlot({
    required this.hora,
    required this.dateTime,
  });
}

class AddAppointmentController extends GetxController {
  final PostAppointmentUsecase postAppointmentUsecase;
  final GetDoctorAvailabilityUsecase getDoctorAvailabilityUsecase;
var selectedBirthDate = Rxn<DateTime>();

  AddAppointmentController({
    required this.postAppointmentUsecase,
    required this.getDoctorAvailabilityUsecase,
  });

  // Controllers de texto
  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  final direccionController = TextEditingController();
  final ciudadController = TextEditingController();
  final codigoPostalController = TextEditingController();
  final coloniaController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final alergiasController = TextEditingController();
  final padecimientosController = TextEditingController();
  final enfermedadesController = TextEditingController();
  final pruebasController = TextEditingController();
  final comentariosController = TextEditingController();
  final motivoController = TextEditingController();

  // Estados observables
  var isLoadingAvailability = false.obs;
  var isSavingAppointment = false.obs;
  var availability = <AvailableDate>[].obs;
  var selectedTipoSangre = Rxn<String>();
  var selectedTipoCita = Rxn<String>();
  var selectedDate = Rxn<AvailableDate>();
  var selectedTime = Rxn<TimeSlot>();

  // Listas estáticas
  final List<String> tiposSangre = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
final List<String> tiposCitaDisplay = ['Primera vez', 'Seguimiento'];
final Map<String, String> tiposCitaMap = {
  'Primera vez': 'primera_vez',
  'Seguimiento': 'seguimiento',
};
  // Intervalo de tiempo para los slots (en minutos)
  final int slotDurationMinutes = 30;
  var nombresError = ''.obs;
  var apellidosError = ''.obs;
  var tipoCitaError = ''.obs;
  var fechaError = ''.obs;
  var horaError = ''.obs;
  @override
  void onInit() {
    super.onInit();
    loadDoctorAvailability();
  }
void clearErrors() {
    nombresError.value = '';
    apellidosError.value = '';
    tipoCitaError.value = '';
    fechaError.value = '';
    horaError.value = '';
  }

  // Cargar disponibilidad del doctor y generar fechas
  Future<void> loadDoctorAvailability() async {
    try {
      isLoadingAvailability.value = true;
      final result = await getDoctorAvailabilityUsecase.getDoctorAvailability();
      
      if (result.isEmpty) {
        showErrorSnackbar('No hay disponibilidad configurada para este doctor');
        return;
      }

      // Generar fechas disponibles basadas en la disponibilidad semanal
      availability.value = _generateAvailableDates(result);
      
      if (availability.isEmpty) {
        showErrorSnackbar('No hay fechas disponibles en los próximos días');
      }
    } catch (e) {
      showErrorSnackbar('No se pudo cargar la disponibilidad del doctor');
      print('Error loading availability: $e');
    } finally {
      isLoadingAvailability.value = false;
    }
  }

  // Generar fechas disponibles para los próximos 14 días
  List<AvailableDate> _generateAvailableDates(List<DoctorAvailabilityEntity> weeklyAvailability) {
    final List<AvailableDate> availableDates = [];
    final now = DateTime.now();
    final daysToGenerate = 14; // Generar 2 semanas de disponibilidad

    // Filtrar solo disponibilidades activas
    final activeAvailability = weeklyAvailability.where((a) => a.activo).toList();
    
    if (activeAvailability.isEmpty) {
      return [];
    }

    for (int i = 0; i < daysToGenerate; i++) {
      final date = now.add(Duration(days: i));
      final dayName = _getDayName(date.weekday);

      // Buscar disponibilidad para este día de la semana
      final dayAvailability = activeAvailability.where(
        (a) => a.diaSemana.toLowerCase() == dayName.toLowerCase()
      ).toList();

      if (dayAvailability.isNotEmpty) {
        // Generar slots de tiempo para este día
        final timeSlots = _generateTimeSlots(date, dayAvailability);
        
        if (timeSlots.isNotEmpty) {
          availableDates.add(AvailableDate(
            date: date,
            diaNombre: _getSpanishDayName(date.weekday),
            timeSlots: timeSlots,
          ));
        }
      }
    }

    return availableDates;
  }

  // Generar slots de tiempo para un día específico
  List<TimeSlot> _generateTimeSlots(DateTime date, List<DoctorAvailabilityEntity> dayAvailability) {
    final List<TimeSlot> slots = [];
    final now = DateTime.now();

    for (var availability in dayAvailability) {
      final startTime = _parseTime(availability.horaInicio);
      final endTime = _parseTime(availability.horaFin);

      if (startTime == null || endTime == null) continue;

      var currentTime = DateTime(
        date.year,
        date.month,
        date.day,
        startTime.hour,
        startTime.minute,
      );

      final endDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        endTime.hour,
        endTime.minute,
      );

      // Generar slots cada 30 minutos (o el intervalo configurado)
      while (currentTime.isBefore(endDateTime)) {
        // Solo agregar slots que sean en el futuro
        if (currentTime.isAfter(now)) {
          slots.add(TimeSlot(
            hora: DateFormat('HH:mm').format(currentTime),
            dateTime: currentTime,
          ));
        }
        currentTime = currentTime.add(Duration(minutes: slotDurationMinutes));
      }
    }

    return slots;
  }

  // Parsear string de hora a DateTime
  TimeOfDay? _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (e) {
      print('Error parsing time: $timeString - $e');
    }
    return null;
  }

  // Obtener nombre del día en inglés (para comparación)
  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Lunes';
      case DateTime.tuesday:
        return 'Martes';
      case DateTime.wednesday:
        return 'Miércoles';
      case DateTime.thursday:
        return 'Jueves';
      case DateTime.friday:
        return 'Viernes';
      case DateTime.saturday:
        return 'Sábado';
      case DateTime.sunday:
        return 'Domingo';
      default:
        return '';
    }
  }

  // Obtener nombre del día en español
  String _getSpanishDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'LUN';
      case DateTime.tuesday:
        return 'MAR';
      case DateTime.wednesday:
        return 'MIÉ';
      case DateTime.thursday:
        return 'JUE';
      case DateTime.friday:
        return 'VIE';
      case DateTime.saturday:
        return 'SÁB';
      case DateTime.sunday:
        return 'DOM';
      default:
        return '';
    }
  }

  // Seleccionar fecha
  void selectDate(AvailableDate date) {
    selectedDate.value = date;
    selectedTime.value = null; // Resetear hora al cambiar fecha
  }

  // Seleccionar hora
  void selectTime(TimeSlot time) {
    selectedTime.value = time;
  }
 bool _validateFields() {
    clearErrors();
    bool isValid = true;

    if (nombresController.text.isEmpty) {
      nombresError.value = 'El nombre es requerido';
      isValid = false;
    }
    
    if (apellidosController.text.isEmpty) {
      apellidosError.value = 'Los apellidos son requeridos';
      isValid = false;
    }
    
    if (selectedTipoCita.value == null) {
      tipoCitaError.value = 'Selecciona un tipo de cita';
      isValid = false;
    }
    
    if (selectedDate.value == null) {
      fechaError.value = 'Selecciona una fecha';
      isValid = false;
    }
    
    if (selectedTime.value == null) {
      horaError.value = 'Selecciona una hora';
      isValid = false;
    }

    if (!isValid) {
    //  showErrorSnackbar('Por favor completa todos los campos requeridos');
    }

    return isValid;
  }
Future<void> saveAppointment() async {
  print('\n╔════════════════════════════════════════════════════════════════╗');
  print('║              INICIANDO GUARDADO DE CITA                        ║');
  print('╚════════════════════════════════════════════════════════════════╝\n');
  
  if (!_validateFields()) {
    print('❌ Validación de campos falló');
    return;
  }
  
  print('✅ Validación de campos exitosa');

  try {
    isSavingAppointment.value = true;

    // Formatear fecha y hora
    final fechaHoraInicio = DateFormat("yyyy-MM-dd'T'HH:mm:ss")
        .format(selectedTime.value!.dateTime);
    
    print('📅 Fecha y hora formateada: $fechaHoraInicio');

    // ✅ Convertir el tipo de cita al formato esperado por el backend
    final tipoCitaBackend = tiposCitaMap[selectedTipoCita.value] ?? selectedTipoCita.value!;
    print('📋 Tipo de cita: ${selectedTipoCita.value} -> $tipoCitaBackend');

    final appointment = AddAppointmentEntity(
      fechaHoraInicio: fechaHoraInicio,
      tipoCita: tipoCitaBackend, // ✅ Usar el valor convertido
      motivoConsulta: motivoController.text,
      nombres: nombresController.text,
      apellidos: apellidosController.text,
      fechaCliente: fechaNacimientoController.text,
      tipoSangre: selectedTipoSangre.value ?? '',
      direccion: direccionController.text,
      ciudad: ciudadController.text,
      codigoPostal: codigoPostalController.text,
      colonia: coloniaController.text,
      correo: correoController.text,
      telefono: telefonoController.text,
      alergias: alergiasController.text,
      padecimientos: padecimientosController.text,
      enfermedadesCirugias: enfermedadesController.text,
      pruebasEstudios: pruebasController.text,
      comentarios: comentariosController.text,
    );
    
    print('\n📋 Datos del appointment:');
    print('  - fechaHoraInicio: ${appointment.fechaHoraInicio}');
    print('  - tipoCita: ${appointment.tipoCita}');
    print('  - nombres: ${appointment.nombres}');
    print('  - apellidos: ${appointment.apellidos}');

    print('\n🚀 Llamando al usecase...');
    await postAppointmentUsecase.execute(appointment);

    print('✅ Cita guardada exitosamente');
    Get.back();
    showSuccessSnackbar('Cita agendada correctamente');

    clearForm();
    
    print('\n╔════════════════════════════════════════════════════════════════╗');
    print('║              CITA GUARDADA CON ÉXITO                          ║');
    print('╚════════════════════════════════════════════════════════════════╝\n');
    
  } catch (e) {
    print('\n╔════════════════════════════════════════════════════════════════╗');
    print('║              ERROR AL GUARDAR CITA                            ║');
    print('╚════════════════════════════════════════════════════════════════╝');
    print('🔴 Error: $e');
    
    String errorMessage = e.toString();
    if (errorMessage.contains('ApiException:')) {
      errorMessage = errorMessage.split('ApiException:')[1].split('(Status')[0].trim();
    }
    errorMessage = errorMessage.replaceAll('Exception:', '').trim();
    
    showErrorSnackbar(errorMessage.isEmpty ? 'Error al agendar la cita' : errorMessage);
  } finally {
    isSavingAppointment.value = false;
  }
}

  // Limpiar formulario
  void clearForm() {
    nombresController.clear();
    apellidosController.clear();
    fechaNacimientoController.clear();
    direccionController.clear();
    ciudadController.clear();
    codigoPostalController.clear();
    coloniaController.clear();
    correoController.clear();
    telefonoController.clear();
    alergiasController.clear();
    padecimientosController.clear();
    enfermedadesController.clear();
    pruebasController.clear();
    comentariosController.clear();
    motivoController.clear();

    selectedTipoSangre.value = null;
    selectedTipoCita.value = null;
    selectedDate.value = null;
    selectedTime.value = null;
    availability.clear();
  }

  @override
  void onClose() {
    // Liberar recursos
    nombresController.dispose();
    apellidosController.dispose();
    fechaNacimientoController.dispose();
    direccionController.dispose();
    ciudadController.dispose();
    codigoPostalController.dispose();
    coloniaController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    alergiasController.dispose();
    padecimientosController.dispose();
    enfermedadesController.dispose();
    pruebasController.dispose();
    comentariosController.dispose();
    motivoController.dispose();
    super.onClose();
  }
  Future<void> selectBirthDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now().subtract(Duration(days: 365 * 25)), // 25 años atrás
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    locale: const Locale('es', 'ES'),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: GerenaColors.primaryColor,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    selectedBirthDate.value = picked;
    fechaNacimientoController.text = DateFormat('yyyy-MM-dd').format(picked);
    print('📅 Fecha de nacimiento seleccionada: ${fechaNacimientoController.text}');
  }
}
}