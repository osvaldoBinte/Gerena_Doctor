import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controlador GetX para el FilterButton
class FilterButtonController extends GetxController {
  final isAscending = true.obs;
  final isActive = false.obs;
  
  void toggleOrder() {
    isAscending.value = !isAscending.value;
  }
  
  void setActive(bool active) {
    isActive.value = active;
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final void Function(bool isAscending)? onChanged;
  final bool? isActive;
  
  FilterButton({
    Key? key,
    required this.text,
    this.onChanged,
    this.isActive,
  }) : super(key: key) {
    // Asignar un ID único basado en el texto para mantener controladores separados
    final String controllerId = 'filter_button_${text.hashCode}';
    
    // Verificar si el controlador ya existe
    if (!Get.isRegistered<FilterButtonController>(tag: controllerId)) {
      // Si no existe, crear una nueva instancia
      final controller = Get.put(FilterButtonController(), tag: controllerId);
      
      // Inicializar el estado activo si se proporciona
      if (isActive != null) {
        controller.isActive.value = isActive!;
      }
    } else if (isActive != null) {
      // Si el controlador ya existe y se proporciona isActive, actualizar su valor
      Get.find<FilterButtonController>(tag: controllerId).isActive.value = isActive!;
    }
  }
  
  // Obtener el controlador para este botón específico
  FilterButtonController get controller => Get.find<FilterButtonController>(tag: 'filter_button_${text.hashCode}');
  
  void _toggleOrder() {
    controller.toggleOrder();
    if (onChanged != null) {
      onChanged!(controller.isAscending.value);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _toggleOrder,
      child: Obx(() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: controller.isActive.value 
              ? const Color.fromARGB(255, 255, 131, 55).withOpacity(0.7)
              : const Color(0xFF181818),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: controller.isActive.value 
                ? const Color.fromARGB(255, 255, 131, 55)
                : Colors.white24,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              controller.isAscending.value ? Icons.arrow_drop_down : Icons.arrow_drop_up,
              color: Colors.white,
            ),
          ],
        ),
      )),
    );
  }
}