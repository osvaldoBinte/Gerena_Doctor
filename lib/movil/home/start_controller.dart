import 'package:flutter/material.dart';
import 'package:gerena/common/services/notification_service.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/doctors/presentation/page/doctorProfilePage/doctor_profilebyid_controller.dart';
import 'package:gerena/features/doctors/presentation/page/doctorProfilePage/doctor_profile_page.dart';
import 'package:gerena/features/notification/presentation/page/notificasiones/notification_page.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/perfil_page.dart';
import 'package:gerena/features/marketplace/presentation/page/Category/category_page.dart';
import 'package:gerena/features/blog/presentation/page/blogGerena/blog_gerena.dart';
import 'package:gerena/features/publications/presentation/page/home_page.dart';
import 'package:gerena/features/subscription/presentation/page/subscription_controller.dart';
import 'package:gerena/features/user/presentation/page/getusebyid/get_user_by_id_controller.dart';
import 'package:gerena/features/user/presentation/page/getusebyid/user_profile_page.dart';
import 'package:gerena/features/user/presentation/page/search/search_profile_page.dart';
import 'package:get/get.dart';

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

class StartController extends GetxController with WidgetsBindingObserver {
  SubscriptionController? get _subscriptionController {
    try {
      return Get.find<SubscriptionController>();
    } catch (e) {
      print('⚠️ SubscriptionController no encontrado: $e');
      return null;
    }
  }

  bool get shouldShowBlog {
    final subscription = _subscriptionController?.currentSubscription.value;
    final planId = subscription?.subscriptionplanId;
    return planId == 4;
  }

  List<Widget> get pages {
    if (shouldShowBlog) {
      return [
        const HomePageMovil(),
        const BlogGerena(),  
        CategoryPage(),
        NotificationPage(),
        DoctorProfilePage(),
      ];
    } else {
      return [
        const HomePageMovil(),
        CategoryPage(),       
        NotificationPage(),
        DoctorProfilePage(),
      ];
    }
  }

  List<String> get iconPaths {
    if (shouldShowBlog) {
      return [
        'assets/icons/home/Home.png',
        'assets/icons/home/Blog.png',
        'assets/icons/home/carrito.png', 
        'assets/icons/home/notificaciones.png',
        'assets/icons/home/Perfil.png',
      ];
    } else {
      return [
        'assets/icons/home/Home.png',
        'assets/icons/home/carrito.png',  
        'assets/icons/home/notificaciones.png',
        'assets/icons/home/Perfil.png',
      ];
    }
  }

  List<String> get selectedIconPaths {
    if (shouldShowBlog) {
      return [
        'assets/icons/home/select/Home.png',
        'assets/icons/home/select/Blog.png',
        'assets/icons/home/select/carrito.png', 
        'assets/icons/home/select/notificacione.png', 
        'assets/icons/home/select/Perfil.png',
      ];
    } else {
      return [
        'assets/icons/home/select/Home.png',
        'assets/icons/home/select/carrito.png',  
        'assets/icons/home/select/notificacione.png', 
        'assets/icons/home/select/Perfil.png',
      ];
    }
  }

  List<String> get notificationIconPaths {
    if (shouldShowBlog) {
      return [
        'assets/icons/home/notificaciones.png',
        'assets/icons/home/notification_new.png',
      ];
    } else {
      return [
        'assets/icons/home/notificaciones.png',
        'assets/icons/home/notification_new.png',
      ];
    }
  }

  List<String> get selectedNotificationIconPaths {
    if (shouldShowBlog) {
      return [
        'assets/icons/home/select/notificacione.png',
        'assets/icons/home/select/notification_new.png',
      ];
    } else {
      return [
        'assets/icons/home/select/notificacione.png',
        'assets/icons/home/select/notification_new.png',
      ];
    }
  }

  final RxList<NavigationHistoryItem> navigationHistory = <NavigationHistoryItem>[].obs;
  
  DateTime? _lastBackPress;
  final Duration _exitTimeLimit = const Duration(seconds: 2);

  final RxInt selectedIndex = 0.obs;
  
  final RxBool showDoctorProfile = false.obs;
  final RxBool showUserProfile = false.obs;
  final RxBool showSearchPage = false.obs;

  final Rx<Map<String, dynamic>?> selectedDoctorData = Rx<Map<String, dynamic>?>(null);
  final Rx<Map<String, dynamic>?> selectedUserData = Rx<Map<String, dynamic>?>(null);

  final notificationService = NotificationService();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    print('🔄 Estado de app cambió a: $state');
    
    if (state == AppLifecycleState.resumed) {
      print('📱 App regresó a primer plano - recargando notificaciones');
      _reloadNotificationState();
    } else if (state == AppLifecycleState.paused) {
      print('⏸️ App fue a segundo plano');
    } else if (state == AppLifecycleState.inactive) {
      print('💤 App inactiva');
    } else if (state == AppLifecycleState.detached) {
      print('🗑️ App detached');
    }
  }

  Future<void> _reloadNotificationState() async {
    try {
      await notificationService.reloadFromStorage();
      print('✅ Estado de notificaciones recargado');
      print('📬 Contador actual: ${notificationService.unreadNotificationsCount.value}');
      print('🔔 Tiene nuevas: ${notificationService.hasNewNotifications.value}');
      
      update();
    } catch (e) {
      print('❌ Error recargando notificaciones: $e');
    }
  }

  void setInitialIndex(int index) {
    if (index >= 0 && index < pages.length) {
      selectedIndex.value = index;
      
      _addToHistory(NavigationHistoryItem(
        pageType: _getPageTypeFromIndex(index),
        pageIndex: index,
      ));
      
      print('📍 Navegando a página inicial: $index');
    }
  }

  void hideUserPage() {
    showUserProfile.value = false;
    selectedUserData.value = null;
  }

  void showSearch() {
    showSearchPage.value = true;
    showDoctorProfile.value = false;
    showUserProfile.value = false;
    
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
    
    final notificationIndex = shouldShowBlog ? 3 : 2;
    
    if (index == notificationIndex) {
      notificationService.clearUnreadCount();
      print('🔔 Usuario en página de notificaciones - contador limpiado');
    }
    
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
    // ✅ Ajustar índice de notificaciones según si hay blog
    final notificationIndex = shouldShowBlog ? 3 : 2;
    
    if (index == notificationIndex) {
      final hasNewNotifications = notificationService.hasNewNotifications.value;
      
      if (showUserProfile.value || showDoctorProfile.value || showSearchPage.value) {
        return hasNewNotifications 
            ? notificationIconPaths[1]
            : notificationIconPaths[0];
      }
      
      return selectedIndex.value == index
          ? (hasNewNotifications 
              ? selectedNotificationIconPaths[1]
              : selectedNotificationIconPaths[0])
          : (hasNewNotifications 
              ? notificationIconPaths[1]
              : notificationIconPaths[0]);
    }
    
    if (showUserProfile.value || showDoctorProfile.value || showSearchPage.value) {
      return iconPaths[index];
    }
    
    return selectedIndex.value == index 
        ? selectedIconPaths[index] 
        : iconPaths[index];
  }
  
  Map<String, dynamic>? get currentDoctorData => selectedDoctorData.value;
  Map<String, dynamic>? get currentUserData => selectedUserData.value;

  Future<bool> handleBackButton() async {
    print('🔙 Botón de retroceso presionado');
    print('📚 Historial actual: ${navigationHistory.length} páginas');
    
    if (navigationHistory.length > 1) {
      navigationHistory.removeLast();
      
      final previousPage = navigationHistory.last;
      
      print('⬅️ Navegando a: ${previousPage.pageType}');
      
      _navigateToHistoryItem(previousPage);
      
      return false;
    }
    
    final now = DateTime.now();
    
    if (_lastBackPress == null || now.difference(_lastBackPress!) > _exitTimeLimit) {
      _lastBackPress = now;
      showWarningSnackbar('Presiona de nuevo para salir de la aplicación');
      print('⚠️ Primer toque - esperando segundo toque');
      return false;
    }
    
    print('🚪 Segundo toque - saliendo de la aplicación');
    return true;
  }

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

  void _addToHistory(NavigationHistoryItem item) {
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

  // ✅ Ajustar PageType según si hay blog
  PageType _getPageTypeFromIndex(int index) {
    if (shouldShowBlog) {
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
    } else {
      switch (index) {
        case 0:
          return PageType.home;
        case 1:
          return PageType.category;
        case 2:
          return PageType.notification;
        case 3:
          return PageType.profile;
        default:
          return PageType.home;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    
    WidgetsBinding.instance.addObserver(this);
    
    _reloadNotificationState();
    
    final arguments = Get.arguments;
    if (arguments is int) {
      setInitialIndex(arguments);
    } else {
      _addToHistory(NavigationHistoryItem(
        pageType: PageType.home,
        pageIndex: 0,
      ));
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    
    navigationHistory.clear();
    _lastBackPress = null;
    super.onClose();
  }
}