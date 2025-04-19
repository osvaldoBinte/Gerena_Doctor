import 'package:flutter/material.dart';
import 'package:managegym/suscripcciones/presentation/widgets/modal_editar_suscripccion.dart';

class CardSubscriptionWidget extends StatelessWidget {
  const CardSubscriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 395,
        height: 250,
        color: Color.fromARGB(60, 40, 40, 40),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child:  Text(
            'aqui va el titulo',
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
            const SizedBox(
              width: double.infinity,
              height: 80,
              child:   Text(
            'aqui va la descripcion',
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
              const Icon(Icons.attach_money, color: Color.fromARGB(255, 255, 152, 0), size: 22),
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
                "32",
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
              const Icon(Icons.calendar_today_rounded, color: Color.fromARGB(255, 54, 162, 255), size: 19),
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
                "1 mes",
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
                      showDialog(context: context, builder: (context){
                        return ModalEditarSuscripccion();
                      } );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 131, 55))),
                    icon: const Icon(Icons.edit)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
