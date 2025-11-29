import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/subscription/domain/entities/mysubcription/my_subcription_entity.dart';
import 'package:gerena/features/subscription/domain/entities/view_all_plans_entity.dart';
import 'package:gerena/features/subscription/domain/usecase/change_subscription_plan_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/get_all_plans_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/get_my_subscription_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/post_cancel_subcription_usecase.dart';
import 'package:gerena/features/subscription/domain/usecase/post_subscribe_to_plan_usecase.dart';
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  final GetAllPlansUsecase getAllPlansUsecase;
  final PostSubscribeToPlanUsecase postSubscribeToPlanUsecase;
  final GetMySubscriptionUsecase getMySubscriptionUsecase;
  final ChangeSubscriptionPlanUsecase changeSubscriptionPlanUsecase;
  final PostCancelSubcriptionUsecase postCancelSubcriptionUsecase;

  SubscriptionController({
    required this.getAllPlansUsecase,
    required this.postSubscribeToPlanUsecase,
    required this.getMySubscriptionUsecase,
    required this.changeSubscriptionPlanUsecase,
    required this.postCancelSubcriptionUsecase,
  });

  var isLoading = true.obs;
  var plans = <ViewAllPlansEntity>[].obs;
  var errorMessage = ''.obs;
  var selectedPaymentMethodId = ''.obs;
  var isCancelling = false.obs; 
  
  Rx<MySubscriptionEntity?> currentSubscription = Rx<MySubscriptionEntity?>(null);
  var hasActiveSubscription = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSubscriptionData();
  }

  Future<void> loadSubscriptionData() async {
    await Future.wait([
      fetchPlans(),
      fetchMySubscription(),
    ]);
  }

  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final result = await getAllPlansUsecase.execute();
      plans.value = result;
    } catch (e) {
      errorMessage.value = 'Error al cargar los planes: $e';
      print('Error fetching plans: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMySubscription() async {
    try {
      final subscription = await getMySubscriptionUsecase.execute();
      currentSubscription.value = subscription;
      hasActiveSubscription.value = subscription.state.toLowerCase() == 'active';
      print('✅ Suscripción actual: ${subscription.planname} - Estado: ${subscription.state}');
    } catch (e) {
      print('ℹ️ No hay suscripción activa: $e');
      currentSubscription.value = null;
      hasActiveSubscription.value = false;
    }
  }

  bool isCurrentPlan(int planId) {
    if (currentSubscription.value == null) return false;
    return currentSubscription.value!.subscriptionplanId == planId.toString();
  }

  Future<void> subscribeToPlan(int planId) async {
    try {
      if (hasActiveSubscription.value) {
        showErrorSnackbar('Ya tienes una suscripción activa. Usa la opción de cambiar plan.');
        return;
      }

      if (selectedPaymentMethodId.value.isEmpty) {
        showErrorSnackbar('Por favor selecciona un método de pago');
        return;
      }

      isLoading.value = true;
      
      await postSubscribeToPlanUsecase.execute(
        selectedPaymentMethodId.value,
        planId,
      );
      
      showSuccessSnackbar('Suscripción realizada correctamente');
      
      await loadSubscriptionData();
      selectedPaymentMethodId.value = '';
      
    } catch (e) {
      showErrorSnackbar('Error al suscribirse al plan: ${e.toString().replaceAll('Exception: ', '')}');
      print('Error subscribing to plan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeSubscriptionPlan(int newPlanId, bool immediateChange) async {
    try {
      if (!hasActiveSubscription.value) {
        showErrorSnackbar('No tienes una suscripción activa para cambiar');
        return;
      }

      if (isCurrentPlan(newPlanId)) {
        showSnackBar('Este ya es tu plan actual', GerenaColors.primaryColor);
        return;
      }

      isLoading.value = true;
      
      await changeSubscriptionPlanUsecase.execute(newPlanId, immediateChange);
      
      showSuccessSnackbar(
        immediateChange 
            ? 'Plan cambiado inmediatamente' 
            : 'El cambio se aplicará al final del período actual'
      );
      
      await loadSubscriptionData();
      
    } catch (e) {
      showErrorSnackbar('Error al cambiar el plan: ${e.toString().replaceAll('Exception: ', '')}');
      print('Error changing subscription plan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelSubscription(bool cancelImmediately, String reason) async {
    try {
      if (!hasActiveSubscription.value) {
        showErrorSnackbar('No tienes una suscripción activa para cancelar');
        return;
      }

      if (reason.trim().isEmpty) {
        showErrorSnackbar('Por favor indica el motivo de la cancelación');
        return;
      }

      isCancelling.value = true;
      
      await postCancelSubcriptionUsecase.execute(cancelImmediately, reason);
      
      showSuccessSnackbar(
        cancelImmediately 
            ? 'Tu suscripción ha sido cancelada inmediatamente' 
            : 'Tu suscripción se cancelará al final del período actual'
      );
      
      await loadSubscriptionData();
      
    } catch (e) {
      showErrorSnackbar('Error al cancelar la suscripción: ${e.toString().replaceAll('Exception: ', '')}');
      print('Error cancelling subscription: $e');
    } finally {
      isCancelling.value = false;
    }
  }

  // Obtener color del botón según el nombre del plan
  Color getButtonColor(String planName) {
    switch (planName.toUpperCase()) {
      case 'BÁSICO':
      case 'BASIC':
        return GerenaColors.secondaryColor;
      case 'PLUS':
      case 'BLACK':
        return GerenaColors.primaryColor;
      case 'ELITE':
        return Colors.red;
      default:
        return GerenaColors.primaryColor;
    }
  }

  bool hasGradientBorder(String planName) {
    return planName.toUpperCase() == 'ELITE';
  }

  bool hasGradientButton(String planName) {
    return planName.toUpperCase() == 'ELITE';
  }
  String getButtonText(int planId, String planName) {
    if (isCurrentPlan(planId)) {
      return 'MI PLAN ACTUAL';
    }
    
    if (hasActiveSubscription.value) {
      return 'CAMBIAR A ESTE PLAN';
    }
    
    if (planName.toUpperCase() == 'PLUS') {
      return 'DOMICILIAR PAGO';
    }
    
    return 'ELEGIR PLAN';
  }

  String getButtonAction(int planId) {
    if (isCurrentPlan(planId)) {
      return 'current';
    }
    
    if (hasActiveSubscription.value) {
      return 'change';
    }
    
    return 'subscribe';
  }
}