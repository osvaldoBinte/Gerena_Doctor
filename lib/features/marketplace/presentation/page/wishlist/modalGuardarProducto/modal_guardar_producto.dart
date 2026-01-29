import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class ModalGuardarProducto extends StatelessWidget {
  const ModalGuardarProducto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: const BoxConstraints(maxWidth: 800),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FRECUENCIA DEL PEDIDO',
                    style: GerenaColors.headingSmall.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Image.asset(
                      'assets/icons/close.png',
                                      width: 20,
    height: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildFrequencyOption('Semanal', false)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildFrequencyOption('Quincenal', false)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildFrequencyOption('Mensual', true)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildFrequencyOption('Personalizado', false)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'FECHA DE INICIO',
                    style: GerenaColors.headingSmall.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.2,
                        child: _buildDateField('01/04/1987'),
                      )),
                  const SizedBox(height: 20),
                  Text(
                    'MÉTODO DE PAGO',
                   style: GerenaColors.headingSmall.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.4,
                        child: _buildPaymentMethod(),
                      )),
                  const SizedBox(height: 20),
                  Text(
                    'DIRECCIÓN DE ENTREGA',
                   style: GerenaColors.headingSmall.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAddressOption(
                    name: 'Juan Pedro Gonzalez Perez +52 3333303333',
                    address:
                        'Col. Providencia, Av. Lorem ipsum #3050, Guadalajara, Jalisco, México.',
                    isSelected: true,
                    hasEditIcon: true,
                  ),
                  const SizedBox(height: 12),
                  _buildAddressOption(
                    name: 'En sucursal',
                    address:
                        'Col. Lorem ipsum Av. Lorem ipsum #3050, Guadalajara, Jalisco, México.',
                    isSelected: false,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CONFIRMACIÓN PREVIA AL ENVÍO',
                              style: GerenaColors.headingSmall.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                            ),
                            const SizedBox(height: 8),
                                Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.3,
                        child:                             _buildDropdownField('Si'),

                      )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FACTURA PROGRAMADA',
                              style: GerenaColors.headingSmall.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                            ),
                            const SizedBox(height: 8),
                              Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                          widthFactor: 0.3,
                        child:                             _buildDropdownField('Si'),

                      )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 160,
                    
                      child:  GerenaColors.widgetButton(
                text: 'PROGRAMAR PEDIDO',
                onPressed: () {
                 
                },
                customShadow: GerenaColors.mediumShadow,
              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyOption(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? GerenaColors.secondaryColor : Colors.white,
        border: Border.all(
          color: isSelected ? GerenaColors.secondaryColor : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : GerenaColors.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildDateField(String date) {
    return Container(
      height: 40,
    
      child: TextFormField(
        initialValue: date,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        style: const TextStyle(fontSize: 13),
      ),
    );
  }Widget _buildPaymentMethod() {
  return Container(
    height: 40,
    width: double.infinity,
    child: DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.zero,
        ),
      ),
      value: 'VISA 5545 15****** 9965',
      icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
      style: const TextStyle(fontSize: 13, color: Colors.black),
      items: const [
        DropdownMenuItem(
          value: 'VISA 5545 15****** 9965',
          child: Text(
            'VISA 5545 15****** 9965',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
      onChanged: (value) {},
    ),
  );
}


  Widget _buildAddressOption({
    required String name,
    required String address,
    required bool isSelected,
    bool hasEditIcon = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isSelected ? GerenaColors.secondaryColor : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(3),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GerenaColors.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: GerenaColors.bodySmall.copyWith(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (hasEditIcon)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: GerenaColors.secondaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }


Widget _buildDropdownField(String value) {
  return Container(
    height: 32,
    constraints: BoxConstraints(minWidth: 0), // ⭐ Permite que se comprima si es necesario
    child: DropdownButtonFormField<String>(
      isExpanded: true,
      isDense: true, // ⭐ Reduce el espacio interno
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 4), // ⭐ Reducido aún más
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.zero,
        ),
      ),
      value: value,
      icon: Padding(
        padding: const EdgeInsets.only(right: 2), // ⭐ Reduce espacio del icono
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey[600],
          size: 14, // ⭐ Reducido de 16 a 14
        ),
      ),
      style: const TextStyle(fontSize: 10, color: Colors.black), // ⭐ Reducido de 11 a 10
      items: [
        DropdownMenuItem(
          value: 'Si',
          child: Text(
            'Si',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        DropdownMenuItem(
          value: 'No',
          child: Text(
            'No',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
      onChanged: (newValue) {},
    ),
  );
}

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const ModalGuardarProducto();
      },
    );
  }
}
