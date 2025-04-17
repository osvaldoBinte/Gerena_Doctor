import 'package:flutter/material.dart';
import 'package:managegym/suscripcciones/presentation/widgets/card_suscription_select_widget.dart';

class ModalAdministrarSuscripccion extends StatelessWidget {
  ModalAdministrarSuscripccion({
    super.key,
  });
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final Color colorFondoDark = const Color.fromARGB(255, 33, 33, 33);

  final ScrollController _scrollController = ScrollController();

  void seleccionarSuscripcion(String id) {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: colorFondoDark,
      content: Container(
        height: 850,
        width: 1458,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Administrar Suscripccion del usuario: Mario Alfredo',
                  style: TextStyle(
                      color: colorTextoDark,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                height: 320,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: GridView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.9,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      return CardSuscriptionSelectWidget(
                        index: index,
                        selectSuscription: seleccionarSuscripcion,
                      );
                    },
                  ),
                )),
            const SizedBox(height: 20),
            HeaderTable(),
            SizedBox(
              width: double.infinity,
              height: 200,
              child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return RowTable(index);
                  }),
            ),
            const SizedBox(
              height: 22,
            ),
            Row(
              children: [
                const Text(
                  'Total a pagar:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 100,
                ),
                const Text(
                  'Paga con:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    style: TextStyle(color: colorTextoDark),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      icon: Icon(
                        Icons.attach_money,
                        color: Colors.white,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 100,
                ),
                const Text(
                  'Cambio:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 75, 55),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        'CANCELAR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 131, 55),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        'PAGAR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
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

  Container RowTable(int index) {
    Color isPair(int index) {
      if (index % 2 == 0) {
        return const Color.fromARGB(255, 33, 33, 33);
      } else {
        return const Color.fromARGB(255, 54, 54, 54);
      }
    }

    return Container(
      height: 38,
      color: isPair(index),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                'Suscripcion $index',
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white),
              )),
          Expanded(
              flex: 1,
              child: Text(
                '1',
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white),
              )),
          Expanded(
              flex: 2,
              child: Text(
                '100.00',
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white),
              )),
          Expanded(
              flex: 2,
              child: Text(
                '100.00',
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }

  Container HeaderTable() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 40, 40, 40),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                'Suscrpccion',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: colorTextoDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
          Expanded(
              flex: 1,
              child: Text(
                'Cantidad',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: colorTextoDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
          Expanded(
              flex: 2,
              child: Text(
                'precio unitario',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: colorTextoDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
          Expanded(
              flex: 2,
              child: Text(
                'Total',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: colorTextoDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              )),
        ],
      ),
    );
  }
}
