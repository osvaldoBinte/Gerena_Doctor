import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/appointment/domain/usecase/get_appointments_usecase.dart';
import 'package:gerena/features/appointment/domain/entities/getappointment/get_apppointment_entity.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

enum CalendarViewType {
  day,
  month,
}

class CalendarControllerGetx extends GetxController {
  final GetAppointmentsUsecase getAppointmentsUsecase;
  CalendarControllerGetx({required this.getAppointmentsUsecase});

  // Inicializar con el día 1 del mes actual
  final Rx<DateTime> focusedDate = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;  
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime(DateTime.now().year, DateTime.now().month, 1));
  final Rx<DateTime?> lastTappedDate = Rx<DateTime?>(null);
  final Rx<CalendarViewType> currentViewType = CalendarViewType.month.obs;
  final RxBool isProcessingViewChange = false.obs;
  final RxList<Appointment> appointments = <Appointment>[].obs;
  final RxBool showAppointmentDetails = false.obs;
  final RxBool isLoading = false.obs;

  final RxInt currentAppointmentIndex = 0.obs;
  late PageController pageController;

  late CalendarController calendarController;

  @override
  void onInit() {
    super.onInit();
    calendarController = CalendarController();
    calendarController.displayDate = focusedDate.value;
    calendarController.selectedDate = selectedDate.value;
    calendarController.view = CalendarView.month;
    
    pageController = PageController(
      viewportFraction: 0.55, 
    );
    
    // Cargar citas de la fecha inicial
    loadAppointmentsForDate(focusedDate.value);
  }

  @override
  void onClose() {
    calendarController.dispose();
    pageController.dispose(); 
    super.onClose();
  }

  void updateCurrentAppointmentIndex(int index) {
    currentAppointmentIndex.value = index;
  }

  void navigateToAppointment(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    updateCurrentAppointmentIndex(index);
  }

  void resetCarouselIndex() {
    currentAppointmentIndex.value = 0;
    if (pageController.hasClients) {
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void updateCurrentDate(DateTime date) {
    focusedDate.value = date;
    selectedDate.value = date;
    calendarController.displayDate = date;
    calendarController.selectedDate = date;
    
    resetCarouselIndex();
    
    // Cargar citas para la nueva fecha
    loadAppointmentsForDate(date);
    
    if (currentViewType.value == CalendarViewType.day) {
      calendarController.view = CalendarView.day;
    } else {
      calendarController.view = CalendarView.month;
    }
  }

  void backToCalendar() {
    showAppointmentDetails.value = false;
  }

  // Cargar citas desde el usecase
  Future<void> loadAppointmentsForDate(DateTime date) async {
    try {
      isLoading.value = true;
      
      // Formatear fecha como string (formato: YYYY-MM-DD)
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // Calcular el número de días del mes
      final daysInMonth = _getDaysInMonth(date.year, date.month);
      
      print('Cargando citas para: $dateString con $daysInMonth días en el mes');
      
      // Obtener citas del usecase pasando la fecha y los días del mes
      final appointmentEntities = await getAppointmentsUsecase.execute(dateString, daysInMonth.toString());
      
      // Convertir entidades a objetos Appointment
      final appointmentsList = appointmentEntities.map((entity) {
        return _convertEntityToAppointment(entity);
      }).toList();
      
      appointments.assignAll(appointmentsList);
      
      print('Citas cargadas: ${appointmentsList.length}');
      
    } catch (e) {
      print('Error al cargar citas: $e');
      appointments.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Obtener el número de días en un mes específico
  int _getDaysInMonth(int year, int month) {
    // Crear una fecha del primer día del siguiente mes y restar un día
    final firstDayNextMonth = DateTime(year, month + 1, 1);
    final lastDayCurrentMonth = firstDayNextMonth.subtract(const Duration(days: 1));
    return lastDayCurrentMonth.day;
  }

  // Convertir GetApppointmentEntity a Appointment
  Appointment _convertEntityToAppointment(GetApppointmentEntity entity) {
    // Parsear las fechas
    final startDateTime = DateTime.parse(entity.startDateTime);
    final endDateTime = DateTime.parse(entity.endDateTime);
    
    return Appointment(
      subject: entity.clientName,
      startTime: startDateTime,
      endTime: endDateTime,
      color: GerenaColors.accentColor,
      notes: entity.consultationReason.isNotEmpty 
          ? 'Procedimiento: ${entity.consultationReason}' 
          : 'Sin motivo especificado',
      location: entity.appointmentType,
      id: entity.id,
    );
  }

  void updateAppointments(List<Appointment> newAppointments) {
    appointments.assignAll(newAppointments);
    resetCarouselIndex(); 
  }

  void addAppointment(Appointment appointment) {
    appointments.add(appointment);
  }

  List<Appointment> getAppointmentsForDate(DateTime date) {
    return appointments.where((appointment) {
      final appointmentDate = appointment.startTime;
      return appointmentDate.year == date.year && 
             appointmentDate.month == date.month && 
             appointmentDate.day == date.day;
    }).toList();
  }

  String getFormattedDate() {
    final months = [
      'ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 
      'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'
    ];
    
    if (currentViewType.value == CalendarViewType.day) {
      return '${focusedDate.value.day} DE ${months[focusedDate.value.month - 1]} ${focusedDate.value.year}';
    } else {
      return '${months[focusedDate.value.month - 1]} ${focusedDate.value.year}';
    }
  }

  String formatSelectedDate(DateTime date) {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    
    return '${date.day} de ${months[date.month - 1]} ${date.year}';
  }

  void handleCalendarTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.calendarCell || 
        details.targetElement == CalendarElement.appointment) {
      
      if (details.date != null) {
        selectedDate.value = details.date;
        
        resetCarouselIndex();
        
        if (currentViewType.value == CalendarViewType.month) {
          calendarController.selectedDate = details.date;
          
          if (details.targetElement == CalendarElement.appointment) {
            lastTappedDate.value = details.date;
          }
        }
      }
    }
  }

  void changeViewType(CalendarViewType viewType) {
    if (currentViewType.value != viewType) {
      currentViewType.value = viewType;
      
      try {
        if (viewType == CalendarViewType.month) {
          calendarController.view = CalendarView.month;
        } else {
          calendarController.view = CalendarView.day;
          
          if (selectedDate.value != null) {
            calendarController.displayDate = selectedDate.value;
            focusedDate.value = selectedDate.value!;
          }
        }
      } catch (e) {
        debugPrint('Error al cambiar la vista: $e');
      }
    }
  }

  void previousPeriod() {
    if (!isProcessingViewChange.value) {
      isProcessingViewChange.value = true;
      
      if (currentViewType.value == CalendarViewType.month) {
        focusedDate.value = DateTime(focusedDate.value.year, focusedDate.value.month - 1, 1);
      } else {
        focusedDate.value = focusedDate.value.subtract(const Duration(days: 1));
        selectedDate.value = focusedDate.value;
      }
      
      resetCarouselIndex();
      
      loadAppointmentsForDate(focusedDate.value);
      
      try {
        calendarController.displayDate = focusedDate.value;
        if (currentViewType.value == CalendarViewType.day) {
          calendarController.selectedDate = focusedDate.value;
        }
      } catch (e) {
        debugPrint('Error al navegar al período anterior: $e');
      }
      
      isProcessingViewChange.value = false;
    }
  }

  void nextPeriod() {
    if (!isProcessingViewChange.value) {
      isProcessingViewChange.value = true;
      
      if (currentViewType.value == CalendarViewType.month) {
        focusedDate.value = DateTime(focusedDate.value.year, focusedDate.value.month + 1, 1);
      } else {
        focusedDate.value = focusedDate.value.add(const Duration(days: 1));
        selectedDate.value = focusedDate.value;
      }
      
      resetCarouselIndex();
      
      // Cargar citas para el nuevo período
      loadAppointmentsForDate(focusedDate.value);
      
      try {
        calendarController.displayDate = focusedDate.value;
        if (currentViewType.value == CalendarViewType.day) {
          calendarController.selectedDate = focusedDate.value;
        }
      } catch (e) {
        debugPrint('Error al navegar al período siguiente: $e');
      }
      
      isProcessingViewChange.value = false;
    }
  }

  void updateFocusedDateFromViewChange(List<DateTime> visibleDates) {
    if (visibleDates.isNotEmpty && !isProcessingViewChange.value) {
      isProcessingViewChange.value = true;
      
      final newFocusedDate = visibleDates[visibleDates.length ~/ 2];
      
      // Solo actualizar y cargar si el mes cambió
      if (focusedDate.value.month != newFocusedDate.month || 
          focusedDate.value.year != newFocusedDate.year) {
        focusedDate.value = newFocusedDate;
        
        // Cargar citas para el nuevo mes
        loadAppointmentsForDate(newFocusedDate);
      }
      
      isProcessingViewChange.value = false;
    }
  }
}