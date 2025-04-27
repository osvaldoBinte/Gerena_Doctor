import 'package:flutter/material.dart';
import 'package:managegym/shared/admin_colors.dart';
import 'package:managegym/suscripcciones/connection/agregarSuscripcion/SuscrpcionModel.dart';

class CardSuscriptionSelectWidget extends StatefulWidget {
  final void Function(String id) selectSuscription;
  final TipoMembresia suscripcion;
  final bool isSelected;
  const CardSuscriptionSelectWidget({
    super.key,
    required this.selectSuscription,
    required this.suscripcion,
    this.isSelected = false,
  });

  @override
  State<CardSuscriptionSelectWidget> createState() =>
      _CardSuscriptionSelectWidgetState();
}

class _CardSuscriptionSelectWidgetState
    extends State<CardSuscriptionSelectWidget> {
  bool isHovering = false;
  final FocusNode _mainFocusNode = FocusNode();

  @override
  void dispose() {
    _mainFocusNode.dispose();
    super.dispose();
  }

  String getDuracionTexto() {
    // Usar 'duracion' si tu modelo ya está actualizado, si no usa 'tiempoDuracion'
    final duracion = widget
        .suscripcion.duracion; // <-- Usa .duracion en vez de .tiempoDuracion
    if (duracion < 30) {
      return "$duracion días";
    } else if (duracion % 30 == 0 && duracion < 365) {
      int meses = (duracion / 30).round();
      return "$meses mes${meses > 1 ? 'es' : ''}";
    } else if (duracion % 365 == 0) {
      int anios = (duracion / 365).round();
      return "$anios año${anios > 1 ? 's' : ''}";
    } else {
      return "$duracion días";
    }
  }

  AdminColors colors = AdminColors();

  @override
  Widget build(BuildContext context) {
    // Colores para mostrar el efecto hover
    const hoverColor = Color.fromARGB(255, 40, 40, 40);

    return InkWell(
      onTap: () {
        widget.selectSuscription(widget.suscripcion.id.toString());
      },
      onHover: (value) {
        setState(() {
          isHovering = value;
        });
      },
      onFocusChange: (value) {
        setState(() {
          isHovering = value;
        });
      },
      focusNode: _mainFocusNode,
      borderRadius: BorderRadius.circular(8),
      hoverColor: const Color.fromARGB(50, 255, 255, 255),
      splashColor: const Color.fromARGB(70, 115, 115, 115),
      highlightColor: const Color.fromARGB(40, 115, 115, 115),
      child: Container(
        decoration: BoxDecoration(
          color: (widget.isSelected || isHovering)
              ? colors.isDarkMode
                  ? hoverColor.withOpacity(0.5)
                  : const Color.fromARGB(255, 241, 241, 241)
              : colors.colorSubsCardBackground,
          borderRadius: BorderRadius.circular(8),
          border: (widget.isSelected || isHovering)
              ? Border.all(
                  color: const Color.fromARGB(255, 255, 131, 55), width: 2.0)
              : null,
          boxShadow: isHovering
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título de la suscripción
            Text(
              widget.suscripcion.titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.colorTexto,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Descripción
            Text(
              widget.suscripcion.descripcion,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.colorTexto,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Precio y duración
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: colors.colorAccionButtons,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isHovering
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            )
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      'Precio: \$${widget.suscripcion.precio}',
                      style: TextStyle(
                          color: colors.colorTexto,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 54, 162, 255),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isHovering
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            )
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      'Duración: ${getDuracionTexto()}',
                      style: TextStyle(
                          color: colors.colorTexto,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
