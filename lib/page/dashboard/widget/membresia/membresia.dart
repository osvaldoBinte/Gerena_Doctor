import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class Membresia extends StatelessWidget {
  const Membresia({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Container(
      color: GerenaColors.backgroundColorfondo,
      child: LayoutBuilder(
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

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  crossAxisSpacing: crossAxisSpacing,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMembershipCard(
                      type:'BASIC',
                      title: 'Disfruta nuestros beneficios esenciales',
                      price: '\$49.00 MXN / mensual',
                      benefits: [
                        'Acceso a la plataforma de compras con precios exclusivos para miembros.',
                        'Gestión de citas y agenda digital básica manual.',
                        'Soporte técnico por chat y correo.',
                        'Acceso a fórmula para 1 cita al mes (individual).',
                        'Historial de pedidos y seguimiento en tiempo real.',
                        'Descuentos en capacitaciones y webinars (5% off).',
                        'Publicidad básica en el directorio de médicos.',
                      ],
                      buttonText: 'ELEGIR PLAN',
                      buttonColor: GerenaColors.secondaryColor,
                      isCurrentPlan: false,
                      screenWidth: constraints.maxWidth,
                    ),
                    _buildMembershipCard(
                      type: 'PLUS',
                      title: 'Automatización y crecimiento del consultorio',
                      subtitle: 'PLUS CIENTÍFICO / EMPRESARIAL',
                      price: '\$125.00 MXN / mensual',
                      benefits: [
                        'Todos los beneficios de Gerena Basic más:',
                        'Gestión de citas avanzada (confirmaciones automáticas por WhatsApp-SMS.',
                        'Acceso al sistema de recompensas y descuentos promocionales.',
                        'Publicidad dentro de la red para atraer pacientes de otras ciudades.',
                        'Webinar clínico digital para cada paciente.',
                        'Videoconsulta (limitadas con pacientes dentro tu app).',
                        '10% de descuento en capacitaciones y webinars.',
                      ],
                      buttonText: 'DOMICILIAR PAGO',
                      buttonColor: GerenaColors.primaryColor,
                      isCurrentPlan: true,
                      currentPlanText: 'MI PLAN ACTUAL',
                      screenWidth: constraints.maxWidth,
                    ),
                    _buildMembershipCard(
                      title: 'Exclusividad y prestigio en el mundo estético',
                      type: 'ELITE',
                      price: '\$275.00 MXN / mensual',
                      benefits: [
                        'Todos los beneficios de Gerena PRO más:',
                        'Integración completa en el directorio con vista de médicos verificados.',
                        'Promoción dentro de productos exclusivos de productos premium.',
                        'Publicidad avanzada en la app + redes sociales de Gerena.',
                        'Prioridad en soporte a nuevos productos y capacitaciones.',
                        'Atención personalizada con un ejecutivo de ventas especializado.',
                        '30% de descuento en capacitaciones y acceso a cursos exclusivos.',
                        'Espacio para subir su propio portafolio digital con fotos de antes y después.',
                      ],
                      buttonText: 'ELEGIR PLAN',
                      buttonColor: Colors.red,
                      isCurrentPlan: false,
                      cardColor: GerenaColors.cardColor,
                      hasGradientBorder: true,
                      hasGradientButton: true,
                      screenWidth: constraints.maxWidth,
                    ),
                    _buildMembershipCard(
                      title: 'Médicos top con máxima visibilidad y beneficios VIP',
                      type: 'BLACK',
                      price: '\$725.00 MXN / mensual',
                      benefits: [
                        'Exclusivo 100 membresías por ciudad',
                        'Todos los beneficios de Gerena Elite más:',
                        'Publicidad masiva en campañas de pago diario en redes sociales.',
                        'Menciones en video semanales y entrevistas exclusivas en el blog de Gerena.',
                        'Página de doctor propia con credenciales de chat, consulta y citas.',
                        'Acceso a campañas de productos antes que nadie.',
                        'Espacio en la home de la app como médico destacado.',
                        'Invitación a eventos y congresos exclusivos de Gerena.',
                        '50% de descuento en capacitaciones y certificaciones.',
                      ],
                      buttonText: 'ELEGIR PLAN',
                      buttonColor: GerenaColors.primaryColor,
                      isCurrentPlan: true,
                      screenWidth: constraints.maxWidth,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
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
  }) {
    // Ajustar tamaños de fuente según el ancho de pantalla
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
          ),
        ),
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        color: cardColor ?? GerenaColors.cardColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        border: borderColor != null 
            ? Border.all(color: borderColor, width: 2)
            : null,
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
                children: benefits.map((benefit) => Padding(
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
                )).toList(),
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
                        onTap: () {
                          print('Plan seleccionado: $title');
                        },
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
                    onPressed: () {
                      print('Plan seleccionado: $title');
                    },
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
}