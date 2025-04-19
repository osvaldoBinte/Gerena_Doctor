import 'package:flutter/material.dart';
import 'package:managegym/suscripcciones/presentation/widgets/modal_editar_suscripccion.dart';

class CardSubscriptionWidget extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final double precio;
  final int tiempoDuracion;

  const CardSubscriptionWidget({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.precio,
    required this.tiempoDuracion,
  });

  String getDuracionTexto() {
    if (tiempoDuracion < 30) {
      // Menos de un mes, mostrar días
      return "$tiempoDuracion días";
    } else if (tiempoDuracion % 30 == 0 && tiempoDuracion < 365) {
      // Multiplo de 30 y menos de un año, mostrar meses
      int meses = (tiempoDuracion / 30).round();
      return "$meses mes${meses > 1 ? 'es' : ''}";
    } else if (tiempoDuracion % 365 == 0) {
      // Multiplo de 365, mostrar años
      int anios = (tiempoDuracion / 365).round();
      return "$anios año${anios > 1 ? 's' : ''}";
    } else {
      return "$tiempoDuracion días";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 395,
        height: 245,
        decoration: BoxDecoration(
          color: const Color.fromARGB(60, 40, 40, 40),
          borderRadius: BorderRadius.circular(18), // Bordes redondeados
        ),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 80,
              child: Text(
                descripcion,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(Icons.attach_money,
                    color: Color.fromARGB(255, 255, 152, 0), size: 22),
                const SizedBox(width: 4),
                Text(
                  "Precio: ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                Text(
                  "$precio",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            // Duración
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    color: Color.fromARGB(255, 54, 162, 255), size: 19),
                const SizedBox(width: 6),
                Text(
                  "Duración: ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  getDuracionTexto(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton.filled(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ModalEditarSuscripccion();
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 131, 55),
                    ),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                  ),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  tooltip: "Editar suscripción",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
