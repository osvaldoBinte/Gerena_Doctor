import 'package:flutter/material.dart';

class CardSuscriptionSelectWidget extends StatefulWidget {
  final void Function(String id) selectSuscription;
  final int index;
  const CardSuscriptionSelectWidget({
    super.key,
    required this.selectSuscription,
    required this.index,
  });

  @override
  State<CardSuscriptionSelectWidget> createState() =>
      _CardSuscriptionSelectWidgetState();
}

class _CardSuscriptionSelectWidgetState
    extends State<CardSuscriptionSelectWidget> {
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);
  bool isHovering = false;
  final FocusNode _mainFocusNode = FocusNode();

  @override
  void dispose() {
    _mainFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colores para mostrar el efecto hover
    const baseColor = Color.fromARGB(255, 23, 23, 23);
    const hoverColor = Color.fromARGB(255, 40, 40, 40);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.selectSuscription(widget.index.toString());
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
        child: Ink(
          decoration: BoxDecoration(
            color: isHovering ? hoverColor : baseColor,
            borderRadius: BorderRadius.circular(8),
            border: isHovering
                ? Border.all(
                    color: const Color.fromARGB(100, 115, 115, 115), width: 1.0)
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Texto
                Text(
                  'Selecciona la suscripción que quieres agregar al cliente',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 18, // Texto más pequeño
                    fontWeight: FontWeight.bold,
                    // Sombra al texto cuando está en hover
                    shadows: isHovering
                        ? [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            )
                          ]
                        : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Botones de precio y duración
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 55, 112, 255),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: Text(
                          'Precio: 299',
                          style: TextStyle(
                              color: colorTextoDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 55, 112, 255),
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
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Text(
                          'Duración: 1m',
                          style: TextStyle(
                              color: Colors.white,
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
        ),
      ),
    );
  }
}