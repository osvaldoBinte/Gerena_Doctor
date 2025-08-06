import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class Membresia extends StatelessWidget {
  const Membresia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GerenaColors.backgroundColorfondo,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 0.70,
              crossAxisSpacing: 40,
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
                                    hasGradientButton: true, // Nueva propiedad para botón gradiente

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
                ),
              ],
            ),
          ],
        ),
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
        bool hasGradientButton = false, // Nueva propiedad

  }) {
    // Si tiene borde gradiente, usar Container con gradiente
    if (hasGradientBorder) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: GerenaColors.mediumBorderRadius,
          gradient: LinearGradient(
            colors: [
             Color(0xFFFF00F6), // Magenta (izquierda arriba)
     Color(0xFF0073FF), // Azul (arriba derecha)
     Color(0xFF8FFF00), // Verde amarillo (abajo derecha)
     Color(0xFFFF7300), // Naranja (abajo derecha tocando rojo)
     Color(0xFFFF0004), // Rojo (izquierda abajo)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(3), // Grosor del borde gradiente
          decoration: BoxDecoration(
            color: cardColor ?? GerenaColors.cardColor,
            borderRadius: BorderRadius.circular(GerenaColors.mediumRadius - 2),
            boxShadow: [GerenaColors.lightShadow],
          ),
          child: _buildCardContent(
            type:type,
            title: title,
            subtitle: subtitle,
            price: price,
            benefits: benefits,
            buttonText: buttonText,
            buttonColor: buttonColor,
            isCurrentPlan: isCurrentPlan,
            currentPlanText: currentPlanText,
            titleColor: titleColor,
                        hasGradientButton: hasGradientButton, // Pasar la propiedad

          ),
        ),
      );
    }
    
    // Card normal sin gradiente
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
                hasGradientButton: hasGradientButton, // Pasar la propiedad

      ),
    );
  }

  // Método separado para el contenido de la card
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
        bool hasGradientButton = false, // Nueva propiedad

  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del plan
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GerenaColors.headingMedium.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? GerenaColors.textPrimaryColor,
                ),
              ),
              Text(
                type,
                style: GerenaColors.headingMedium.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? GerenaColors.textPrimaryColor,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GerenaColors.bodySmall.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: titleColor ?? GerenaColors.textPrimaryColor,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                price,
                style: GerenaColors.bodyMedium.copyWith(
                  fontSize: 13,
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
                            fontSize: 15,
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
          
          // Plan actual indicator (si aplica)
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
                style: const TextStyle(
                  color: GerenaColors.secondaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          
          // Botón de acción
         SizedBox(
            width: double.infinity,
            height: 40,
            child: hasGradientButton
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFC2639C), // Rosa/magenta
                          Color(0xFFFF0101), // Rojo brillante
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
                            style: const TextStyle(
                              fontSize: 12,
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
                      // Lógica para seleccionar plan
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
                      style: const TextStyle(
                        fontSize: 12,
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