import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/home/dashboard/dashboard_controller.dart';
import 'package:gerena/features/home/dashboard/dashboard_page.dart';

class PreguntasFrecuentes extends StatelessWidget {
  const PreguntasFrecuentes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
          padding:const  EdgeInsets.symmetric(horizontal: 60.0),

      child: Container(
        color: GerenaColors.backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              'Preguntas frecuentes',
              style: GerenaColors.headingLarge.copyWith(fontSize: 22),
            ),
            
            const SizedBox(height: 24),
            
            _buildFAQItem(
              question: '¿Cómo puedo realizar un pedido de productos?',
              answer: 'Desde tu portafolio de inicio puedes acceder al catálogo de Gerena haciendo clic en el botón "Catálogo" o directamente en la imagen "representativa del producto que deseas comprar.\n\nUna vez dentro del catálogo puedes ir agregando los productos que necesitas al carrito de compras. En cualquier momento, puedes hacer clic en el icono del carrito para continuar con tu compra, confirmar los productos seleccionados y la dirección de entrega.\n\nAl finalizar, se te brindará un número de folio para que puedas dar seguimiento a tu pedido y realizar tu facturación correspondiente.',
            ),
            
            _buildFAQItem(
              question: '¿Qué beneficios tengo como doctor registrado en la app?',
              answer: 'Los beneficios y promociones dependen directamente de la membresía contratada.\n\nSi deseas conocer los beneficios disponibles para ti, puedes consultarlos en la sección "Membresías" dentro de tu perfil, o haciendo click aquí',
              hasLink: true,
            ),
            
            _buildFAQItem(
              question: '¿Cómo programo mis pedidos desde la wishlist?',
              answer: 'Puedes acceder a tu wishlist desde el menú desplegable de Gerena o haciendo clic en el icono del corazón.\n\nEsto te llevará a tus listas creadas, donde podrás seleccionar la opción "Programar pedido".\n\nAl hacerlo, se te solicitará información como la frecuencia del pedido, método de pago y dirección de entrega.\n\nUna vez configurada, recibirás tus productos de forma automática según la programación.\n\nPuedes pausar o activar esta programación en cualquier momento.',
            ),
            
            _buildFAQItem(
              question: '¿Cómo funciona la agenda de pacientes y ¿Puedo integrarla con mi calendario?',
              answer: 'Según la membresía que hayas adquirido en Gerena, podrás habilitar funciones como:\n\n• Agendación automática de citas\n• Confirmación de disponibilidad vía WhatsApp\n• Registro manual de citas directamente en tu calendario de la app',
            ),
            
            _buildFAQItem(
              question: '¿Qué hago si tengo problemas con un pedido o necesito soporte?',
              answer: 'Si necesitas ayuda con el seguimiento de un pedido, realizar una compra o resolver dudas sobre pagos, facturación, acceso a clases, webinars o cambios de membresía, puedes contactar a tu ejecutivo asignado dentro del horario de atención.\n\nPara problemas técnicos relacionados con la app, la gestión de citas o su funcionamiento general, puedes solicitar asistencia a través de Gerena Bot.',
            ),
            
            _buildFAQItem(
              question: '¿Puedo compartir mi portafolio con pacientes?',
              answer: 'Sí. Las membresías que incluyen el portafolio permiten compartirlo automáticamente en tu perfil dentro de la aplicación para pacientes de Gerena.\n\nEsto les permite conocer tu trabajo y agendar citas directamente contigo.',
            ),
          ],
        ),
      ),
      )
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    bool hasLink = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      padding: const EdgeInsets.all(16.0),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GerenaColors.headingSmall.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          RichText(
            text: TextSpan(
              style: GerenaColors.bodyMedium.copyWith(
                fontSize: 13,
                height: 1.5,
                color: GerenaColors.textPrimaryColor,
              ),
              children: _buildAnswerSpans(answer, hasLink),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildAnswerSpans(String answer, bool hasLink) {
    if (!hasLink) {
      return [
        TextSpan(text: answer),
      ];
    }
    
    final parts = answer.split('click aquí');
    if (parts.length == 2) {
      return [
        TextSpan(text: parts[0]),
        TextSpan(
          text: 'click aquí',
          style: TextStyle(
            color: GerenaColors.accentColor,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w500,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _navigateToMembresia();
            },
        ),
        if (parts[1].isNotEmpty) TextSpan(text: parts[1]),
      ];
    }
    
    return [TextSpan(text: answer)];
  }

  void _navigateToMembresia() {
    try {
      if (!Get.isRegistered<DashboardController>()) {
        Get.put(DashboardController());
      }
      
      final dashboardController = Get.find<DashboardController>();
      dashboardController.showMembresia();
      
      
      print('Navegación exitosa a membresía desde FAQ');
    } catch (e) {
      print('Error en navegación a membresía: $e');
    }
  }
}