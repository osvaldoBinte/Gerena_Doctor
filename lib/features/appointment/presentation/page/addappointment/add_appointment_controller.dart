import 'package:gerena/features/appointment/domain/entities/addappointment/add_appointment_entity.dart';
import 'package:gerena/features/appointment/domain/usecase/post_appointment_usecase.dart';
import 'package:gerena/features/doctors/domain/entities/doctoravailability/doctor_availability_entity.dart';
import 'package:gerena/features/doctors/domain/usecase/get_doctor_availability_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAppointmentController extends GetxController {
  final PostAppointmentUsecase postAppointmentUsecase;
  final GetDoctorAvailabilityUsecase getDoctorAvailabilityUsecase;

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
  var availability = <DoctorAvailabilityEntity>[].obs;
  var selectedTipoSangre = Rxn<String>();
  var selectedTipoCita = Rxn<String>();
  var selectedDate = Rxn<DoctorAvailabilityEntity>();
  var selectedTime = Rxn<HorariosDisponiblesEntity>();

  // Listas estáticas
  final List<String> tiposSangre = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> tiposCita = ['Primera vez', 'Seguimiento', 'Urgencia'];

  // Cargar disponibilidad del doctor
  Future<void> loadDoctorAvailability() async {
    try {
      isLoadingAvailability.value = true;
      final result = await getDoctorAvailabilityUsecase.getDoctorAvailability(
        
      );
      availability.value = result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cargar la disponibilidad del doctor',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoadingAvailability.value = false;
    }
  }

  // Seleccionar fecha
  void selectDate(DoctorAvailabilityEntity date) {
    selectedDate.value = date;
    selectedTime.value = null; // Resetear hora al cambiar fecha
  }

  // Seleccionar hora
  void selectTime(HorariosDisponiblesEntity time) {
    selectedTime.value = time;
  }

  // Validar campos requeridos
  bool _validateFields() {
    if (nombresController.text.isEmpty) {
      _showError('El nombre es requerido');
      return false;
    }
    if (apellidosController.text.isEmpty) {
      _showError('Los apellidos son requeridos');
      return false;
    }
    if (selectedTipoCita.value == null) {
      _showError('Selecciona un tipo de cita');
      return false;
    }
    if (selectedDate.value == null) {
      _showError('Selecciona una fecha');
      return false;
    }
    if (selectedTime.value == null) {
      _showError('Selecciona una hora');
      return false;
    }
    return true;
  }

  // Guardar cita
  Future<void> saveAppointment() async {
    if (!_validateFields()) return;

    try {
      isSavingAppointment.value = true;

      final fechaHoraInicio = '${selectedDate.value!.fecha} ${selectedTime.value!.hora}';

      final appointment = AddAppointmentEntity(
       
        fechaHoraInicio: fechaHoraInicio,
        tipoCita: selectedTipoCita.value!,
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

      await postAppointmentUsecase.execute(appointment);

      Get.back();
      Get.snackbar(
        'Éxito',
        'Cita agendada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );

      // Limpiar formulario después de guardar
      clearForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo agendar la cita: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isSavingAppointment.value = false;
    }
  }

  // Mostrar error
  void _showError(String message) {
    Get.snackbar(
      'Campos requeridos',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange[100],
      colorText: Colors.orange[900],
    );
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
}