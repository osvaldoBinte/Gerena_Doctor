import 'package:get/get.dart';

class ControllerPerfilConfiguration extends GetxController {
  final RxBool showConfiguration = false.obs;
  final RxBool showPatientProfile = false.obs;
  final Rx<dynamic> selectedAppointment = Rx<dynamic>(null);
  
  void showConfigurationView() {
    showConfiguration.value = true;
  }
  
  void hideConfigurationView() {
    showConfiguration.value = false;
  }
  
  void toggleView() {
    showConfiguration.value = !showConfiguration.value;
  }
  
  // Nuevos métodos para el perfil del paciente
  void showPatientProfileView(dynamic appointment) {
    selectedAppointment.value = appointment;
    showPatientProfile.value = true;
  }
  
  void hidePatientProfileView() {
    showPatientProfile.value = false;
    selectedAppointment.value = null;
  }
}