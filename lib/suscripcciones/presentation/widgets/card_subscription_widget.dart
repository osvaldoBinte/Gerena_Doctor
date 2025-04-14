import 'package:flutter/material.dart';



class CardSubscriptionWidget extends StatelessWidget {
  const CardSubscriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 395,
        height: 230,
        color: Color.fromARGB(60, 40, 40, 40),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text("Suscripccion basica sin coach por 1 mes y mas cosas xd ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              width: double.infinity,
              height: 100,
              child: Text("Hola soy la descripccion de la suscripcccion",
                  style: TextStyle(
                      color: Colors.white,
                      )),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2, horizontal: 13),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 55, 112, 255)),
                  child: const Text("Precio: 1000",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                  Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2, horizontal: 13),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 55, 112, 255)),
                  child: const Text("Duracion: 1 mes",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 20),
                IconButton.filled(onPressed: (){}, style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 131, 55))),icon: const Icon(Icons.edit)),
              ],
            )
          ],
        ),
      ),
    );
  }
}