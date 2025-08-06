import 'package:flutter/material.dart';
import 'package:gerena/movil/homePage/home_page.dart';
import 'package:gerena/movil/perfil/perfil_page.dart';
import 'package:gerena/page/dashboard/widget/notificasiones/notification_modal.dart';
import 'package:gerena/page/store/blogGerena/blog_gerena.dart';
import 'package:get/get.dart';

class StartController extends GetxController {
  // ✅ Actualizado: Agregada nueva página para Blog
  final List<Widget> pages = [
    const HomePageMovil(),
    const BlogGerena(), // Nueva página que necesitas crear
    const CartPage(), // Nueva página que necesitas crear o puedes usar CalendarWidget()
    NotificationModal(),
    DoctorProfilePage(),
   
  ];

  final List<String> iconPaths = [
    'assets/icons/home/Home.png',
    'assets/icons/home/Blog.png',
    'assets/icons/home/carrito.png', 
    'assets/icons/home/notificacione.png',
    'assets/icons/home/Perfil.png',
  ];

  final List<String> selectedIconPaths = [
    'assets/icons/home/select/Home.png',
    'assets/icons/home/select/Blog.png',
    'assets/icons/home/carrito.png', 
    'assets/icons/home/select/notificaciones.png', 
    'assets/icons/home/select/Perfil.png',
  ];

  final RxInt selectedIndex = 0.obs;
  final RxBool showAgendarCita = false.obs;
  final RxBool showTendencias = false.obs;
  final RxBool showDoctorSearch = false.obs;
  final RxBool showDoctorProfile = false.obs;
  final RxBool showCalendar = false.obs; // ✅ Agregado para el calendario

  void changePage(int index) {
    selectedIndex.value = index;
    _hideAllOverlayPages(); // ✅ Método simplificado
  }

  // ✅ Método simplificado para ocultar todas las páginas overlay
  void _hideAllOverlayPages() {
    showAgendarCita.value = false;
    showTendencias.value = false;
    showDoctorSearch.value = false;
    showDoctorProfile.value = false;
    showCalendar.value = false;
  }

  void showAgendarCitaPage() {
    _hideAllOverlayPages();
    showAgendarCita.value = true;
  }

  void hideAgendarCitaPage() {
    showAgendarCita.value = false;
  }

  void showTendenciasPage() {
    _hideAllOverlayPages();
    showTendencias.value = true;
  }

  void hideTendenciasPage() {
    showTendencias.value = false;
  }

  void showDoctorSearchPage() {
    _hideAllOverlayPages();
    showDoctorSearch.value = true;
  }

  void hideDoctorSearchPage() {
    showDoctorSearch.value = false;
  }

  void showDoctorProfilePage() {
    _hideAllOverlayPages();
    showDoctorProfile.value = true;
  }

  void hideDoctorProfilePage() {
    showDoctorProfile.value = false;
  }

  // ✅ Nuevo método para mostrar calendario como overlay (opcional)
  void showCalendarPage() {
    _hideAllOverlayPages();
    showCalendar.value = true;
  }

  void hideCalendarPage() {
    showCalendar.value = false;
  }

  Widget get currentPage {
   
    return pages[selectedIndex.value];
  }

  // ✅ Actualizado: Incluye la nueva página de calendario
  bool get shouldShowBottomNav => !showAgendarCita.value && 
                                  !showTendencias.value && 
                                  !showDoctorSearch.value && 
                                  !showDoctorProfile.value &&
                                  !showCalendar.value;

  String getIconPath(int index) {
    // Si hay alguna página overlay activa, mostrar iconos normales
    if (showAgendarCita.value || showTendencias.value || showDoctorSearch.value || showDoctorProfile.value || showCalendar.value) {
      return iconPaths[index];
    }
    
    // Mostrar icono seleccionado o normal según el índice actual
    return selectedIndex.value == index 
        ? selectedIconPaths[index] 
        : iconPaths[index];
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blog')),
      body: Center(
        child: Text('Página de Blog'),
      ),
    );
  }
}


class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carrito')),
      body: Center(
        child: Text('Página de Carrito'),
      ),
    );
  }
}