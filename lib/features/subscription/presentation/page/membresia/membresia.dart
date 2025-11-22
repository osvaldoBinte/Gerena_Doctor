import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/subscription/domain/entities/view_all_plans_entity.dart';
import 'package:gerena/features/subscription/presentation/page/membresia/CancelSubscriptionDialog.dart';
import 'package:gerena/features/subscription/presentation/page/membresia/ChangePlanDialog.dart';
import 'package:gerena/features/subscription/presentation/page/membresia/SelectPaymentMethodDialog%20.dart';
import 'package:gerena/features/subscription/presentation/page/subscription_controller.dart';
import 'package:get/get.dart';

class Membresia extends StatelessWidget {
  const Membresia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SubscriptionController>();

    return Container(
      color: GerenaColors.backgroundColorfondo,
      child: Obx(() {
        if (controller.isLoading.value && controller.plans.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: GerenaColors.primaryColor,
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty && controller.plans.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: GerenaColors.textSecondaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: GerenaColors.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadSubscriptionData(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GerenaColors.primaryColor,
                  ),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount;
            double horizontalPadding;
            double crossAxisSpacing;
            double childAspectRatio;

            if (constraints.maxWidth < 600) {
              crossAxisCount = 1;
              horizontalPadding = 16.0;
              crossAxisSpacing = 16.0;
              childAspectRatio = 0.85;
            } else if (constraints.maxWidth < 900) {
              crossAxisCount = 2;
              horizontalPadding = 32.0;
              crossAxisSpacing = 24.0;
              childAspectRatio = 0.75;
            } else {
              crossAxisCount = 2;
              horizontalPadding = 60.0;
              crossAxisSpacing = 40.0;
              childAspectRatio = 0.70;
            }

            return RefreshIndicator(
              onRefresh: () => controller.loadSubscriptionData(),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.hasActiveSubscription.value) ...[
                      _buildCurrentSubscriptionBanner(controller),
                      const SizedBox(height: 24),
                    ],

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: crossAxisSpacing,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: controller.plans.length,
                      itemBuilder: (context, index) {
                        final plan = controller.plans[index];
                        final isCurrentPlan = controller.isCurrentPlan(plan.id);

                        return _buildMembershipCard(
                          type: plan.name,
                          title: plan.description,
                          price: '\$${plan.price.toStringAsFixed(2)} MXN / ${plan.interval == 'month' ? 'mensual' : plan.interval}',
                          benefits: plan.caracteristicas.beneficios,
                          buttonText: controller.getButtonText(plan.id, plan.name),
                          buttonColor: controller.getButtonColor(plan.name),
                          isCurrentPlan: isCurrentPlan,
                          currentPlanText: isCurrentPlan ? 'MI PLAN ACTUAL' : null,
                          hasGradientBorder: controller.hasGradientBorder(plan.name),
                          hasGradientButton: controller.hasGradientButton(plan.name),
                          screenWidth: constraints.maxWidth,
                          onTap: () => _handlePlanTap(context, controller, plan),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildCurrentSubscriptionBanner(SubscriptionController controller) {
  final subscription = controller.currentSubscription.value;
  if (subscription == null) return SizedBox.shrink();

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          GerenaColors.primaryColor,
          GerenaColors.primaryColor.withOpacity(0.8),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: GerenaColors.primaryColor.withOpacity(0.3),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.stars, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              'Tu Plan Actual',
              style: GerenaColors.headingMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription.planname,
                    style: GerenaColors.headingLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${subscription.planprice.toStringAsFixed(2)} MXN / mes',
                    style: GerenaColors.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                subscription.state.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.8), size: 16),
            const SizedBox(width: 6),
            Text(
              'Renovación: ${_formatDate(subscription.currentPeriodEnddate)}',
              style: GerenaColors.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        
        if (subscription.cancelledAtPeriodEnd) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tu suscripción se cancelará al finalizar el período el ${_formatDate(subscription.currentPeriodEnddate)}',
                    style: GerenaColors.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),
        const Divider(color: Colors.white24, thickness: 1),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: Get.context!,
                builder: (context) => CancelSubscriptionDialog(),
              );
            },
            icon: Icon(
              subscription.cancelledAtPeriodEnd 
                  ? Icons.refresh 
                  : Icons.cancel_outlined,
              size: 18,
            ),
            label: Text(
              subscription.cancelledAtPeriodEnd 
                  ? 'Reactivar suscripción' 
                  : 'Cancelar suscripción',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    ),
  );
}
void _handlePlanTap(BuildContext context, SubscriptionController controller, ViewAllPlansEntity plan) {
  final action = controller.getButtonAction(plan.id);

  if (action == 'current') {
            showSuccessSnackbar( 'Este es tu plan actual. Usa el botón "Cancelar suscripción" en el banner superior si deseas cancelar.');

  } else if (action == 'change') {
   
    showDialog(
      context: context,
      builder: (context) => ChangePlanDialog(newPlan: plan),
    );
  } else {
    _showSubscriptionDialog(context, plan);
  }
}

  void _showSubscriptionDialog(BuildContext context, ViewAllPlansEntity plan) {
    showDialog(
      context: context,
      builder: (context) => SelectPaymentMethodDialog(plan: plan),
    );
  }

  Widget _buildMembershipCard({
    required String type,
    required String title,
    String? subtitle,
    required String price,
    required List<String> benefits,
    required String buttonText,
    required Color buttonColor,
    required bool isCurrentPlan,
    String? currentPlanText,
    Color? cardColor,
    Color? borderColor,
    Color? titleColor,
    bool hasGradientBorder = false,
    bool hasGradientButton = false,
    required double screenWidth,
    VoidCallback? onTap,
  }) {
    double titleFontSize = screenWidth < 600 ? 18 : 15;
    double typeFontSize = screenWidth < 600 ? 28 : 24;
    double subtitleFontSize = screenWidth < 600 ? 12 : 10;
    double priceFontSize = screenWidth < 600 ? 16 : 13;
    double benefitFontSize = screenWidth < 600 ? 16 : 15;
    double buttonFontSize = screenWidth < 600 ? 14 : 12;
    double cardPadding = screenWidth < 600 ? 20 : 16;

    if (hasGradientBorder) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: GerenaColors.mediumBorderRadius,
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF00F6),
              Color(0xFF0073FF),
              Color(0xFF8FFF00),
              Color(0xFFFF7300),
              Color(0xFFFF0004),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: cardColor ?? GerenaColors.cardColor,
            borderRadius: BorderRadius.circular(GerenaColors.mediumRadius - 2),
            boxShadow: [GerenaColors.lightShadow],
          ),
          child: _buildCardContent(
            type: type,
            title: title,
            subtitle: subtitle,
            price: price,
            benefits: benefits,
            buttonText: buttonText,
            buttonColor: buttonColor,
            isCurrentPlan: isCurrentPlan,
            currentPlanText: currentPlanText,
            titleColor: titleColor,
            hasGradientButton: hasGradientButton,
            titleFontSize: titleFontSize,
            typeFontSize: typeFontSize,
            subtitleFontSize: subtitleFontSize,
            priceFontSize: priceFontSize,
            benefitFontSize: benefitFontSize,
            buttonFontSize: buttonFontSize,
            cardPadding: cardPadding,
            onTap: onTap,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cardColor ?? GerenaColors.cardColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        border: borderColor != null ? Border.all(color: borderColor, width: 2) : null,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: _buildCardContent(
        title: title,
        type: type,
        subtitle: subtitle,
        price: price,
        benefits: benefits,
        buttonText: buttonText,
        buttonColor: buttonColor,
        isCurrentPlan: isCurrentPlan,
        currentPlanText: currentPlanText,
        titleColor: titleColor,
        hasGradientButton: hasGradientButton,
        titleFontSize: titleFontSize,
        typeFontSize: typeFontSize,
        subtitleFontSize: subtitleFontSize,
        priceFontSize: priceFontSize,
        benefitFontSize: benefitFontSize,
        buttonFontSize: buttonFontSize,
        cardPadding: cardPadding,
        onTap: onTap,
      ),
    );
  }

  Widget _buildCardContent({
    required String type,
    required String title,
    String? subtitle,
    required String price,
    required List<String> benefits,
    required String buttonText,
    required Color buttonColor,
    required bool isCurrentPlan,
    String? currentPlanText,
    Color? titleColor,
    bool hasGradientButton = false,
    required double titleFontSize,
    required double typeFontSize,
    required double subtitleFontSize,
    required double priceFontSize,
    required double benefitFontSize,
    required double buttonFontSize,
    required double cardPadding,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.all(cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GerenaColors.headingMedium.copyWith(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? GerenaColors.textPrimaryColor,
                ),
              ),
              Text(
                type,
                style: GerenaColors.headingMedium.copyWith(
                  fontSize: typeFontSize,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? GerenaColors.textPrimaryColor,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GerenaColors.bodySmall.copyWith(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w600,
                    color: titleColor ?? GerenaColors.textPrimaryColor,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                price,
                style: GerenaColors.bodyMedium.copyWith(
                  fontSize: priceFontSize,
                  fontWeight: FontWeight.w600,
                  color: titleColor ?? GerenaColors.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            color: GerenaColors.primaryColor.withOpacity(0.3),
            thickness: 2,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: benefits
                    .map((benefit) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: titleColor ?? GerenaColors.textPrimaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: GerenaColors.bodySmall.copyWith(
                                    fontSize: benefitFontSize,
                                    height: 1.3,
                                    color: titleColor ?? GerenaColors.textPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (isCurrentPlan && currentPlanText != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                currentPlanText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GerenaColors.secondaryColor,
                  fontSize: buttonFontSize + 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            height: 40,
            child: hasGradientButton
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFC2639C),
                          Color(0xFFFF0101),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: buttonFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return 'N/A';
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }
}