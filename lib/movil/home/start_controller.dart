import 'package:flutter/material.dart';
import 'package:gerena/features/doctors/presentation/page/doctorProfilePage/doctor_profile_controller.dart';
import 'package:gerena/features/notification/presentation/page/notificasiones/notification_page.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/perfil_page.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_page.dart';
import 'package:gerena/features/notification/presentation/page/notificasiones/notification_modal.dart';
import 'package:gerena/features/blog/presentation/page/blogGerena/blog_gerena.dart';
import 'package:gerena/features/publications/presentation/page/home_page.dart';
import 'package:gerena/features/user/presentation/page/getusebyid/get_user_by_id_controller.dart';
import 'package:gerena/features/user/presentation/page/getusebyid/user_profile_page.dart';
import 'package:get/get.dart';

class StartController extends GetxController {
  final List<Widget> pages = [
    const HomePageMovil(),
    const BlogGerena(),
     CategoryPage(),
    NotificationPage(),
    DoctorProfilePage(),
   
  ];

  final List<String> iconPaths = [
    'assets/icons/home/Home.png',
    'assets/icons/home/Blog.png',
    'assets/icons/home/carrito.png', 
    'assets/icons/home/notificaciones.png',
    'assets/icons/home/Perfil.png',
  ];

  final List<String> selectedIconPaths = [
    'assets/icons/home/select/Home.png',
    'assets/icons/home/select/Blog.png',
    'assets/icons/home/select/carrito.png', 
    'assets/icons/home/select/notificacione.png', 
    'assets/icons/home/select/Perfil.png',
  ];
  void setInitialIndex(int index) {
    if (index >= 0 && index < pages.length) {
      selectedIndex.value = index;
      print('📍 Navegando a página inicial: $index');
    }
  }
  final RxInt selectedIndex = 0.obs;
  void hideUserPage() {
    showUserProfile.value = false;
    selectedUserData.value = null;
  }
  final RxBool showDoctorProfile = false.obs;
    final RxBool showUserProfile = false.obs;
  final Rx<Map<String, dynamic>?> selectedDoctorData = Rx<Map<String, dynamic>?>(null);
final Rx<Map<String, dynamic>?> selectedUserData = Rx<Map<String, dynamic>?>(null);

  void changePage(int index) {
    selectedIndex.value = index;

    showDoctorProfile.value = false;
    showUserProfile.value = false;
    selectedDoctorData.value = null;
    selectedUserData.value = null;
    _hideAllOverlayPages();
  }

void showUserProfilePage({Map<String, dynamic>? userData}) {
  if (userData != null) {
    selectedUserData.value = userData;
    print('📋 Datos del usuario guardados en StartController:');
    print('   - Nombre: ${userData['userName']}');
    print('   - ID: ${userData['userId']}');
    print('   - Username: ${userData['username']}');
  }
  
  showUserProfile.value = true;
  showDoctorProfile.value = false;
  
  if (Get.isRegistered<GetUserByIdController>()) {
    final controller = Get.find<GetUserByIdController>();
    controller.loadUserData();
  }
}
void showDoctorProfilePage({Map<String, dynamic>? doctorData}) {

    if (doctorData != null) {
      selectedDoctorData.value = doctorData;
      print('📋 Datos del doctor guardados en StartController:');
      print('   - Nombre: ${doctorData['doctorName']}');
      print('   - ID: ${doctorData['userId']}');
      print('   - Especialidad: ${doctorData['specialty']}');
    }
    showDoctorProfile.value = true;
    if (Get.isRegistered<DoctorProfileController>()) {
      final controller = Get.find<DoctorProfileController>();
      controller.loadDoctorData();
    }
  }
  void _hideAllOverlayPages() {
    showDoctorProfile.value = false;
  }
  void hideDoctorProfilePage() {
    showDoctorProfile.value = false;
  }
  Widget get currentPage {
  
    if (showDoctorProfile.value) {
      return DoctorProfilePage();
    }
    if (showUserProfile.value) {
      return UserProfilePage();
    }
    return pages[selectedIndex.value];
  }

  bool get shouldShowBottomNav => 
                                  !showDoctorProfile.value &&
                                  !showUserProfile.value;

  String getIconPath(int index) {
    if (showUserProfile.value || showDoctorProfile.value) {
      return iconPaths[index];
    }
    
    return selectedIndex.value == index 
        ? selectedIconPaths[index] 
        : iconPaths[index];
  }
  
  Map<String, dynamic>? get currentDoctorData => selectedDoctorData.value;
Map<String, dynamic>? get currentUserData => selectedUserData.value;
@override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is int) {
      setInitialIndex(arguments);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}