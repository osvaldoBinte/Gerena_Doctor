import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DashboardController extends GetxController {
  // Estado del calendario
  final RxBool isCalendarFullScreen = false.obs;
  
  // Variable para controlar qué vista mostrar
  final RxString currentView = 'calendar'.obs; 
  
  // Variables para las citas médicas
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxList<Appointment> selectedAppointments = <Appointment>[].obs;

  // Función para manejar la selección de fecha
  void onDateSelected(DateTime date) {
    // Aquí puedes agregar lógica adicional si es necesario
    print('Fecha seleccionada en DashboardController: $date');
  }

  // Función para mostrar el calendario a pantalla completa
  void showCalendarFullScreen() {
    isCalendarFullScreen.value = true;
    currentView.value = 'calendar';
  }

  // Función para salir del modo pantalla completa
  void exitCalendarFullScreen() {
    isCalendarFullScreen.value = false;
    currentView.value = 'calendar';
  }

  // Función para mostrar las citas médicas
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

  // Función para mostrar el perfil del doctor
  void showDoctorProfile() {
    currentView.value = 'doctor_profile';
    // Limpiar estados anteriores si es necesario
    selectedDate.value = null;
    selectedAppointments.clear();
    isCalendarFullScreen.value = false;
  }

  // NUEVA FUNCIÓN: Mostrar el perfil del usuario
  void showUserProfile() {
    currentView.value = 'user_profile';
    // Limpiar estados anteriores si es necesario
    selectedDate.value = null;
    selectedAppointments.clear();
    isCalendarFullScreen.value = false;
  }
 void showUSugerencia() {
    currentView.value = 'sugerencia';
    // Limpiar estados anteriores si es necesario
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
  bool get isShowingUserProfile => currentView.value == 'user_profile'; // NUEVA
  bool get isShowSugerencia => currentView.value == 'sugerencia'; // NUEVA
  bool get isShowPreguntasFrecuentes => currentView.value == 'PreguntasFrecuentes';

}