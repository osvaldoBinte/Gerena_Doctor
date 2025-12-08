import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  // Mapa para controlar qué post muestra las opciones de reacción
  final RxMap<int, bool> showReactionOptionsMap = <int, bool>{}.obs;
  
  // Mapa para la reacción seleccionada de cada post
  final RxMap<int, int?> selectedReactionMap = <int, int?>{}.obs;
  
  final List<String> reactionIcons = [
    'assets/icons/reacciones/recomendar.png',
    'assets/icons/reacciones/meencanta.png',
    'assets/icons/reacciones/measombra.png',
    'assets/icons/reacciones/lonecesito.png',
  ];
  
  final List<String> reactionNames = [
    'Recomendar',
    'Me encanta',
    'Me asombra',
    'Lo necesito',
  ];

  final List<String> reactionTypes = [
    'like',
    'meEncanta',
    'meAsombra',
    'loNecesito',
  ];

  // Colores para cada tipo de reacción
  final List<Color> reactionColors = [
    Color(0xFFE91E63), // Verde para "Recomendar"
    Color(0xFFE91E63), // Rosa para "Me encanta"
    Color(0xFFE91E63), // Rojo/Naranja para "Me asombra"
    Color(0xFFE91E63), // Azul para "Lo necesito"
  ];

  // Método para obtener el índice de la reacción según el tipo del API
  int getReactionIndexFromType(String? reactionType) {
    if (reactionType == null) return 0;
    
    switch (reactionType) {
      case 'like':
        return 0;
      case 'meEncanta':
        return 1;
      case 'meAsombra':
        return 2;
      case 'loNecesito':
        return 3;
      default:
        return 0;
    }
  }

  // Inicializar la reacción del usuario para un post
  void initializeUserReaction(int postId, String? userReaction) {
    if (userReaction != null) {
      selectedReactionMap[postId] = getReactionIndexFromType(userReaction);
    } else {
      selectedReactionMap[postId] = null;
    }
  }
  
  void toggleReactionOptions(int postId) {
    showReactionOptionsMap[postId] = !(showReactionOptionsMap[postId] ?? false);
    showReactionOptionsMap.refresh();
  }
  
  bool isShowingReactionOptions(int postId) {
    return showReactionOptionsMap[postId] ?? false;
  }
  
  void selectReaction(int postId, int index) {
    selectedReactionMap[postId] = index;
    showReactionOptionsMap[postId] = false;
  }
  
  String? getSelectedReactionIcon(int postId) {
    final selectedIndex = selectedReactionMap[postId];
    if (selectedIndex != null) {
      return reactionIcons[selectedIndex];
    }
    return reactionIcons[0];
  }
  
  String getSelectedReactionName(int postId) {
    final selectedIndex = selectedReactionMap[postId];
    if (selectedIndex != null) {
      return reactionNames[selectedIndex];
    }
    return reactionNames[0];
  }

  // Obtener el color de la reacción seleccionada
  Color getSelectedReactionColor(int postId) {
    final selectedIndex = selectedReactionMap[postId];
    if (selectedIndex != null) {
      return reactionColors[selectedIndex];
    }
    return Color(0xFFF0F0F0); // Color por defecto (blanco/gris claro)
  }

  // Verificar si el usuario ya reaccionó a un post
  bool hasUserReacted(int postId) {
    return selectedReactionMap[postId] != null;
  }

  String getReactionType(int index) {
    return reactionTypes[index];
  }

  Color getReactionColor(int index) {
    return reactionColors[index];
  }

  String getCurrentReactionType(int postId) {
    final selectedIndex = selectedReactionMap[postId];
    if (selectedIndex != null) {
      return reactionTypes[selectedIndex];
    }
    return reactionTypes[0];
  }
  
  void resetReaction(int postId) {
    selectedReactionMap[postId] = null;
    showReactionOptionsMap[postId] = false;
  }
  
  void closeReactionOptions(int postId) {
    showReactionOptionsMap[postId] = false;
  }

  void closeAllReactionOptions() {
    showReactionOptionsMap.clear();
  }
}