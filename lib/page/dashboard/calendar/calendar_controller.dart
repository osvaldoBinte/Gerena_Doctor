import 'package:gerena/common/theme/App_Theme.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

enum CalendarViewType {
  day,
  month,
}

class CalendarControllerGetx extends GetxController {

  final Rx<DateTime> focusedDate = DateTime(2025, 4, 28).obs;  
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime(2025, 4, 28));
  final Rx<DateTime?> lastTappedDate = Rx<DateTime?>(null);
  final Rx<CalendarViewType> currentViewType = CalendarViewType.month.obs;
  final RxBool isProcessingViewChange = false.obs;
  final RxList<Appointment> appointments = <Appointment>[].obs;
  final RxBool showAppointmentDetails = false.obs;

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
    
    loadDefaultAppointments();
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
    
    if (currentViewType.value == CalendarViewType.day) {
      calendarController.view = CalendarView.day;
    } else {
      calendarController.view = CalendarView.month;
    }
  }

  void backToCalendar() {
    showAppointmentDetails.value = false;
  }

  void loadDefaultAppointments() {
    final List<Appointment> defaultAppointments = <Appointment>[];
    
    final int year = 2025;
    final int month = 4;
    
    final DateTime startTime1 = DateTime(year, month, 28, 10, 30);
    final DateTime endTime1 = startTime1.add(const Duration(hours: 1));
    defaultAppointments.add(Appointment(
      subject: 'Fabiola Gómez Gómez',
      startTime: startTime1,
      endTime: endTime1,
      color: GerenaColors.accentColor,
      notes: 'Procedimiento: Relleno Dérmico De Labios',
      location: 'Seguimiento',
    ));
    
    final DateTime startTime2 = DateTime(year, month, 28, 12, 30);
    final DateTime endTime2 = startTime2.add(const Duration(hours: 1));
    defaultAppointments.add(Appointment(
      subject: 'Jessica Fernández Gutiérrez',
      startTime: startTime2,
      endTime: endTime2,
      color: GerenaColors.accentColor,
      notes: 'Procedimiento: Toxina Botulínica En Tercio Superior Del Rostro',
      location: 'Primera cita',
    ));
    
    final DateTime startTime3 = DateTime(year, month, 28, 15, 0);
    final DateTime endTime3 = startTime3.add(const Duration(hours: 1));
    defaultAppointments.add(Appointment(
      subject: 'Andrés Flores Pacheco',
      startTime: startTime3,
      endTime: endTime3,
      color: GerenaColors.accentColor,
      notes: 'Procedimiento: Toxina Botulínica En Tercio Superior Del Rostro',
      location: 'Seguimiento',
    ));
    
    final DateTime startTime4 = DateTime(year, month, 30, 12, 30);
    final DateTime endTime4 = startTime4.add(const Duration(hours: 1));
    defaultAppointments.add(Appointment(
      subject: 'Jessica Fernandez Gutierrez',
      startTime: startTime4,
      endTime: endTime4,
      color: GerenaColors.accentColor,
      notes: 'Procedimiento: Toxina Botulínica En Tercio Superior Del Rostro',
      location: 'Primera Cita',
    ));
    
    final DateTime startTime5 = DateTime(year, month, 19, 14, 0);
    final DateTime endTime5 = startTime5.add(const Duration(hours: 1));
    defaultAppointments.add(Appointment(
      subject: 'Laura Méndez Torres',
      startTime: startTime5,
      endTime: endTime5,
      color: GerenaColors.accentColor,
      notes: 'Procedimiento: Aplicación de Enzimas Reductoras',
      location: 'Seguimiento',
    ));
    
    for (var appointment in defaultAppointments) {
      print('Cargando cita: ${appointment.subject} - ${appointment.startTime} - ${appointment.endTime}');
    }
    
    appointments.assignAll(defaultAppointments);
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
      focusedDate.value = visibleDates[visibleDates.length ~/ 2];
      isProcessingViewChange.value = false;
    }
  }
}