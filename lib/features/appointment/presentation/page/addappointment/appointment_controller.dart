import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/appointment/domain/usecase/appointment_completed_usecase.dart';
import 'package:gerena/features/appointment/domain/usecase/cancel_appointment_usecase.dart';
import 'package:gerena/features/appointment/presentation/page/calendar/calendar_controller.dart';
import 'package:gerena/features/home/dashboard/dashboard_controller.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  final CancelAppointmentUsecase cancelAppointmentUsecase;
  final AppointmentCompletedUsecase appointmentCompletedUsecase;
  
  AppointmentController({
    required this.appointmentCompletedUsecase,
    required this.cancelAppointmentUsecase,
  });

    final controller = Get.put(DashboardController());
  final RxBool isCancelingAppointment = false.obs;
  final RxBool isCompletingAppointment = false.obs;

  final RxBool showMotivoError = false.obs;
  final RxString motivoError = ''.obs;

  final RxBool showNotasError = false.obs;
  final RxString notasError = ''.obs;
  final RxBool showDiagnosticoError = false.obs;
  final RxString diagnosticoError = ''.obs;

  void validateMotivo(String value) {
    if (value.trim().isEmpty) {
      showMotivoError.value = true;
      motivoError.value = 'El motivo de cancelación es requerido';
    } else {
      showMotivoError.value = false;
      motivoError.value = '';
    }
  }

  void validateNotas(String value) {
    if (value.trim().isEmpty) {
      showNotasError.value = true;
      notasError.value = 'Las notas del doctor son requeridas';
    } else {
      showNotasError.value = false;
      notasError.value = '';
    }
  }

  void validateDiagnostico(String value) {
    if (value.trim().isEmpty) {
      showDiagnosticoError.value = true;
      diagnosticoError.value = 'El diagnóstico es requerido';
    } else {
      showDiagnosticoError.value = false;
      diagnosticoError.value = '';
    }
  }

  void resetCancelValidations() {
    showMotivoError.value = false;
    motivoError.value = '';
  }

  void resetCompleteValidations() {
    showNotasError.value = false;
    notasError.value = '';
    showDiagnosticoError.value = false;
    diagnosticoError.value = '';
  }

  // 🔥 Método helper para recargar el calendario
  Future<void> _reloadCalendar() async {
    try {
      final calendarController = Get.find<CalendarControllerGetx>();
      final currentDate = calendarController.selectedDate.value ?? DateTime.now();
      
      // Recargar las citas del mes actual
      await calendarController.loadAppointmentsForDate(currentDate);
      
      print('✅ Calendario recargado exitosamente');
    } catch (e) {
      print('⚠️ Error al recargar calendario: $e');
    }
  }

  Future<void> cancelAppointment(int appointmentId, String motivoCancelacion) async {
    validateMotivo(motivoCancelacion);
    
    if (showMotivoError.value) {
      return;
    }

    try {
      isCancelingAppointment.value = true;
      
      await cancelAppointmentUsecase.execute(appointmentId, motivoCancelacion);
      
      Get.back(); // Cerrar el modal
      
      // 🔥 Recargar el calendario después de cancelar
      await _reloadCalendar();
       controller.showCalendar();
      showSuccessSnackbar('La cita ha sido cancelada correctamente');
      resetCancelValidations();
      
    } catch (e) {
      showErrorSnackbar('No se pudo cancelar la cita: ${e.toString()}');
    } finally {
      isCancelingAppointment.value = false;
    }
  }

  Future<void> completeAppointment(
    int appointmentId,
    String notasDoctor,
    String diagnostico,
  ) async {
    validateNotas(notasDoctor);
    validateDiagnostico(diagnostico);

    if (showNotasError.value || showDiagnosticoError.value) {
      return;
    }

    try {
      isCompletingAppointment.value = true;
      
      await appointmentCompletedUsecase.execute(
        appointmentId,
        notasDoctor,
        diagnostico,
      );
      
      Get.back();
      
      await _reloadCalendar();
       controller.showCalendar();
      showSuccessSnackbar('La cita ha sido completada correctamente');
      resetCompleteValidations();
      
    } catch (e) {
      showErrorSnackbar('No se pudo completar la cita: ${e.toString()}');
    } finally {
      isCompletingAppointment.value = false;
    }
  }
}