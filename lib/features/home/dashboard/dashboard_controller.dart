import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DashboardController extends GetxController {
  final RxBool isCalendarFullScreen = false.obs;
  
  final RxString currentView = 'calendar'.obs; 
  
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxList<Appointment> selectedAppointments = <Appointment>[].obs;

  void onDateSelected(DateTime date) {
    print('Fecha seleccionada en DashboardController: $date');
  }

  void showCalendarFullScreen() {
    isCalendarFullScreen.value = true;
    currentView.value = 'calendar';
  }

  void exitCalendarFullScreen() {
    isCalendarFullScreen.value = false;
    currentView.value = 'calendar';
  }

  void showMedicalAppointments(DateTime date, List<Appointment> appointments) {
    selectedDate.value = date;
    selectedAppointments.assignAll(appointments);
    currentView.value = 'appointments';
  }

  void showMembresia() {
      currentView.value = 'membresia';
    }
    void showCalendar() {
    currentView.value = 'calendar';
    selectedDate.value = null;
    selectedAppointments.clear();
  }

  void showDoctorProfile() {
    currentView.value = 'doctor_profile';
    selectedDate.value = null;
    selectedAppointments.clear();
    isCalendarFullScreen.value = false;
  }

  void showUserProfile() {
    currentView.value = 'user_profile';
    selectedDate.value = null;
    selectedAppointments.clear();
    isCalendarFullScreen.value = false;
  }
 void showUSugerencia() {
    currentView.value = 'sugerencia';
    selectedDate.value = null;
    selectedAppointments.clear();
    isCalendarFullScreen.value = false;
  }
  void showMainView() {
    currentView.value = 'calendar';
    selectedDate.value = null;
    selectedAppointments.clear();
    isCalendarFullScreen.value = false;
  }
  void showPreguntasFrecuentes() {
    currentView.value = 'PreguntasFrecuentes';
    selectedDate.value = null;
    selectedAppointments.clear();
    isCalendarFullScreen.value = false;
  }
  bool get isShowingAppointments => currentView.value == 'appointments';
  bool get isShowingCalendar => currentView.value == 'calendar';
  bool get isShowingDoctorProfile => currentView.value == 'doctor_profile';
  bool get isShowingUserProfile => currentView.value == 'user_profile';
  bool get isShowSugerencia => currentView.value == 'sugerencia';
  bool get isShowPreguntasFrecuentes => currentView.value == 'PreguntasFrecuentes';

}