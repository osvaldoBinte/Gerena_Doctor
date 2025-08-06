import 'package:get/get.dart';

class PostController extends GetxController {
  var showReactionOptions = false.obs;
  
  var selectedReaction = RxnInt();
  
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
  
  void toggleReactionOptions() {
    showReactionOptions.value = !showReactionOptions.value;
  }
  
  void selectReaction(int index) {
    selectedReaction.value = index;
    showReactionOptions.value = false; 
  }
  
  String? getSelectedReactionIcon() {
    if (selectedReaction.value != null) {
      return reactionIcons[selectedReaction.value!];
    }
    return reactionIcons[0]; 
  }
  
  String getSelectedReactionName() {
    if (selectedReaction.value != null) {
      return reactionNames[selectedReaction.value!];
    }
    return reactionNames[0];
  }
  
  void resetReaction() {
    selectedReaction.value = null;
    showReactionOptions.value = false;
  }
  
  void closeReactionOptions() {
    showReactionOptions.value = false;
  }
}