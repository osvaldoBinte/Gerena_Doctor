import 'package:flutter/material.dart';
import 'package:gerena/common/errors/convert_message.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/appointment/domain/entities/availability/add_availability_entity.dart';
import 'package:gerena/features/appointment/domain/usecase/add_availability_usecase.dart';
import 'package:gerena/features/appointment/domain/usecase/delete_availability_usecase.dart';
import 'package:gerena/features/doctors/domain/entities/doctoravailability/doctor_availability_entity.dart';
import 'package:gerena/features/doctors/domain/usecase/get_doctor_availability_usecase.dart';
import 'package:get/get.dart';

// Importa tu archivo de snackbars
import 'package:gerena/common/widgets/snackbar_helper.dart'; // Ajusta la ruta

class AvailabilityController extends GetxController {
  final AddAvailabilityUsecase addAvailabilityUsecase;
  final DeleteAvailabilityUsecase deleteAvailabilityUsecase;
  final GetDoctorAvailabilityUsecase getDoctorAvailabilityUsecase;

  AvailabilityController({
    required this.addAvailabilityUsecase,
    required this.deleteAvailabilityUsecase,
    required this.getDoctorAvailabilityUsecase,
  });

  var availabilities = <DoctorAvailabilityEntity>[].obs;
  var isLoading = false.obs;
  var selectedDay = Rx<DateTime?>(null);
  var selectedStartTime = Rx<String?>(null);
  var selectedEndTime = Rx<String?>(null);
  var currentView = 'appointments'.obs;

  // Días de la semana en español (MAYÚSCULAS para el backend)
  final daysOfWeek = [
    'LUNES',
    'MARTES',
    'MIÉRCOLES',
    'JUEVES',
    'VIERNES',
    'SÁBADO',
    'DOMINGO'
  ];

  final availableTimes = [
    '08:00', '08:30', '09:00', '09:30', '10:00', '10:30',
    '11:00', '11:30', '12:00', '12:30', '13:00', '13:30',
    '14:00', '14:30', '15:00', '15:30', '16:00', '16:30',
    '17:00', '17:30', '18:00', '18:30', '19:00', '19:30',
    '20:00'
  ];

  @override
  void onInit() {
    super.onInit();
    loadDoctorAvailability();
  }

  Future<void> loadDoctorAvailability() async {
    try {
      isLoading.value = true;
      final result = await getDoctorAvailabilityUsecase.getDoctorAvailability();
      availabilities.value = result;
    } catch (e) {
      showErrorSnackbar('No se pudo cargar la disponibilidad ${cleanExceptionMessage(e)}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAvailability() async {
    if (selectedDay.value == null ||
        selectedStartTime.value == null ||
        selectedEndTime.value == null) {
      showSnackBar(
        'Por favor selecciona día, hora de inicio y hora de fin',
        GerenaColors.warningColor,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      final dayOfWeek = daysOfWeek[selectedDay.value!.weekday - 1];
      
      final entity = AddAvailabilityEntity(
        dayOfWeek: dayOfWeek,
        startTime: selectedStartTime.value!,
        endTime: selectedEndTime.value!,
      );print('=== NUEVA AVAILABILITY ===');
print('dayOfWeek: $dayOfWeek');
print('startTime: ${selectedStartTime.value}');
print('endTime: ${selectedEndTime.value}');
print('Entity completo: $entity');
print('==========================');

      await addAvailabilityUsecase.execute([entity]);
      print( selectedStartTime.value);
      showSuccessSnackbar('Disponibilidad agregada correctamente');

      await loadDoctorAvailability();
      clearSelection();
      
    } catch (e) {

      showErrorSnackbar('No se pudo agregar la disponibilidad ${cleanExceptionMessage(e)}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeAvailability(int id) async {
    try {
      isLoading.value = true;
      await deleteAvailabilityUsecase.execute(id);
      
      showSuccessSnackbar('Disponibilidad eliminada correctamente');
      await loadDoctorAvailability();
    } catch (e) {
      showErrorSnackbar('No se pudo eliminar la disponibilidad');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleView() {
    currentView.value = 
        currentView.value == 'appointments' ? 'availability' : 'appointments';
  }

  void selectDay(DateTime day) {
    selectedDay.value = day;
  }

  void selectStartTime(String time) {
    selectedStartTime.value = time;
    if (selectedEndTime.value != null &&
        _compareTime(selectedEndTime.value!, time) <= 0) {
      selectedEndTime.value = null;
    }
  }

  void selectEndTime(String time) {
    if (selectedStartTime.value == null) {
      showSnackBar(
        'Primero selecciona la hora de inicio',
        GerenaColors.warningColor,
      );
      return;
    }
    
    if (_compareTime(time, selectedStartTime.value!) <= 0) {
      showSnackBar(
        'La hora de fin debe ser posterior a la hora de inicio',
        GerenaColors.warningColor,
      );
      return;
    }
    
    selectedEndTime.value = time;
  }

  void clearSelection() {
    selectedDay.value = null;
    selectedStartTime.value = null;
    selectedEndTime.value = null;
  }

  int _compareTime(String time1, String time2) {
    final parts1 = time1.split(':');
    final parts2 = time2.split(':');
    
    final hour1 = int.parse(parts1[0]);
    final minute1 = int.parse(parts1[1]);
    
    final hour2 = int.parse(parts2[0]);
    final minute2 = int.parse(parts2[1]);
    
    if (hour1 != hour2) {
      return hour1.compareTo(hour2);
    }
    return minute1.compareTo(minute2);
  }

  List<String> getAvailableEndTimes() {
    if (selectedStartTime.value == null) return [];
    
    return availableTimes
        .where((time) => _compareTime(time, selectedStartTime.value!) > 0)
        .toList();
  }
}