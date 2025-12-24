import 'package:flutter/material.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/doctors/presentation/page/doctorProfilePage/doctor_profilebyid_controller.dart';
import 'package:gerena/features/doctors/presentation/page/doctorProfilePage/doctor_profile_page.dart';
import 'package:gerena/features/notification/presentation/page/notificasiones/notification_page.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/perfil_page.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_page.dart';
import 'package:gerena/features/blog/presentation/page/blogGerena/blog_gerena.dart';
import 'package:gerena/features/publications/presentation/page/home_page.dart';
import 'package:gerena/features/user/presentation/page/getusebyid/get_user_by_id_controller.dart';
import 'package:gerena/features/user/presentation/page/getusebyid/user_profile_page.dart';
import 'package:gerena/features/user/presentation/page/search/search_profile_page.dart';
import 'package:get/get.dart';

// NUEVO: Enum para identificar tipos de página
enum PageType {
  home,
  blog,
  category,
  notification,
  profile,
  doctorProfile,
  userProfile,
  search,
}

// NUEVO: Clase para el historial de navegación
class NavigationHistoryItem {
  final PageType pageType;
  final int? pageIndex;
  final Map<String, dynamic>? data;

  NavigationHistoryItem({
    required this.pageType,
    this.pageIndex,
    this.data,
  });
}

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

  // NUEVO: Historial de navegación
  final RxList<NavigationHistoryItem> navigationHistory = <NavigationHistoryItem>[].obs;
  
  // NUEVO: Control para doble toque para salir
  DateTime? _lastBackPress;
  final Duration _exitTimeLimit = const Duration(seconds: 2);

  void setInitialIndex(int index) {
    if (index >= 0 && index < pages.length) {
      selectedIndex.value = index;
      
      // NUEVO: Agregar al historial
      _addToHistory(NavigationHistoryItem(
        pageType: _getPageTypeFromIndex(index),
        pageIndex: index,
      ));
      
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
  final RxBool showSearchPage = false.obs;

  final Rx<Map<String, dynamic>?> selectedDoctorData = Rx<Map<String, dynamic>?>(null);
  final Rx<Map<String, dynamic>?> selectedUserData = Rx<Map<String, dynamic>?>(null);

  void showSearch() {
    showSearchPage.value = true;
    showDoctorProfile.value = false;
    showUserProfile.value = false;
    
    // NUEVO: Agregar al historial
    _addToHistory(NavigationHistoryItem(
      pageType: PageType.search,
    ));
  }

  void hideSearch() {
    showSearchPage.value = false;
  }

  void changePage(int index) {
    selectedIndex.value = index;

    showDoctorProfile.value = false;
    showUserProfile.value = false;
    selectedDoctorData.value = null;
    selectedUserData.value = null;
    _hideAllOverlayPages();
    
    // NUEVO: Agregar al historial
    _addToHistory(NavigationHistoryItem(
      pageType: _getPageTypeFromIndex(index),
      pageIndex: index,
    ));
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
    showSearchPage.value = false;

    // NUEVO: Agregar al historial
    _addToHistory(NavigationHistoryItem(
      pageType: PageType.userProfile,
      data: userData,
    ));

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
    showSearchPage.value = false;

    // NUEVO: Agregar al historial
    _addToHistory(NavigationHistoryItem(
      pageType: PageType.doctorProfile,
      data: doctorData,
    ));

    if (Get.isRegistered<DoctorProfilebyidController>()) {
      final controller = Get.find<DoctorProfilebyidController>();
      controller.loadDoctorData();
    }
  }

  void _hideAllOverlayPages() {
    showDoctorProfile.value = false;
    showUserProfile.value = false;
    showSearchPage.value = false;
  }

  void hideDoctorProfilePage() {
    showDoctorProfile.value = false;
  }

  Widget get currentPage {
    if (showSearchPage.value) {
      return SearchProfilePage();
    }

    if (showDoctorProfile.value) {
      return DoctorProfileByidPage();
    }

    if (showUserProfile.value) {
      return UserProfilePage();
    }

    return pages[selectedIndex.value];
  }

  bool get shouldShowBottomNav => 
    !showDoctorProfile.value &&
    !showUserProfile.value &&
    !showSearchPage.value;

  String getIconPath(int index) {
    if (showUserProfile.value || showDoctorProfile.value || showSearchPage.value) {
      return iconPaths[index];
    }
    
    return selectedIndex.value == index 
        ? selectedIconPaths[index] 
        : iconPaths[index];
  }
  
  Map<String, dynamic>? get currentDoctorData => selectedDoctorData.value;
  Map<String, dynamic>? get currentUserData => selectedUserData.value;

  // NUEVO: Método para manejar el botón de retroceso
  Future<bool> handleBackButton() async {
    print('🔙 Botón de retroceso presionado');
    print('📚 Historial actual: ${navigationHistory.length} páginas');
    
    // Si hay más de una página en el historial
    if (navigationHistory.length > 1) {
      // Remover la página actual
      navigationHistory.removeLast();
      
      // Obtener la página anterior
      final previousPage = navigationHistory.last;
      
      print('⬅️ Navegando a: ${previousPage.pageType}');
      
      // Navegar a la página anterior
      _navigateToHistoryItem(previousPage);
      
      // No salir de la app
      return false;
    }
    
    // Si solo hay una página (la inicial), verificar doble toque para salir
    final now = DateTime.now();
    
    if (_lastBackPress == null || now.difference(_lastBackPress!) > _exitTimeLimit) {
      // Primer toque - mostrar mensaje
      _lastBackPress = now;
      showWarningSnackbar('Presiona de nuevo para salir de la aplicación');
      print('⚠️ Primer toque - esperando segundo toque');
      return false;
    }
    
    // Segundo toque dentro del tiempo límite - permitir salir
    print('🚪 Segundo toque - saliendo de la aplicación');
    return true;
  }

  // NUEVO: Navegar a un item del historial
  void _navigateToHistoryItem(NavigationHistoryItem item) {
    _hideAllOverlayPages();
    
    switch (item.pageType) {
      case PageType.home:
      case PageType.blog:
      case PageType.category:
      case PageType.notification:
      case PageType.profile:
        selectedIndex.value = item.pageIndex ?? 0;
        break;
        
      case PageType.doctorProfile:
        selectedDoctorData.value = item.data;
        showDoctorProfile.value = true;
        if (Get.isRegistered<DoctorProfilebyidController>()) {
          final controller = Get.find<DoctorProfilebyidController>();
          controller.loadDoctorData();
        }
        break;
        
      case PageType.userProfile:
        selectedUserData.value = item.data;
        showUserProfile.value = true;
        if (Get.isRegistered<GetUserByIdController>()) {
          final controller = Get.find<GetUserByIdController>();
          controller.loadUserData();
        }
        break;
        
      case PageType.search:
        showSearchPage.value = true;
        break;
    }
  }

  // NUEVO: Agregar al historial (evita duplicados consecutivos)
  void _addToHistory(NavigationHistoryItem item) {
    // Si el último item es el mismo, no agregarlo
    if (navigationHistory.isNotEmpty) {
      final lastItem = navigationHistory.last;
      if (lastItem.pageType == item.pageType && 
          lastItem.pageIndex == item.pageIndex) {
        print('⏭️ Evitando duplicado en el historial');
        return;
      }
    }
    
    navigationHistory.add(item);
    print('➕ Agregado al historial: ${item.pageType} (Total: ${navigationHistory.length})');
  }

  // NUEVO: Convertir índice a PageType
  PageType _getPageTypeFromIndex(int index) {
    switch (index) {
      case 0:
        return PageType.home;
      case 1:
        return PageType.blog;
      case 2:
        return PageType.category;
      case 3:
        return PageType.notification;
      case 4:
        return PageType.profile;
      default:
        return PageType.home;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is int) {
      setInitialIndex(arguments);
    } else {
      // Agregar página inicial al historial si no se especifica
      _addToHistory(NavigationHistoryItem(
        pageType: PageType.home,
        pageIndex: 0,
      ));
    }
  }

  @override
  void onClose() {
    navigationHistory.clear();
    _lastBackPress = null;
    super.onClose();
  }
}