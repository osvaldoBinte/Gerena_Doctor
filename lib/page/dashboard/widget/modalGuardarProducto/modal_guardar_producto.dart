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
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: GerenaColors.mediumBorderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con título y botón cerrar
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
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
                    
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            
            // Contenido del modal
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Opciones de frecuencia
                  Row(
                    children: [
                      Expanded(child: _buildFrequencyOption('Semanal', false)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildFrequencyOption('Quincenal', false)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildFrequencyOption('Mensual', true)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildFrequencyOption('Personalizado', false)),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Fecha de inicio
                  Text(
                    'FECHA DE INICIO',
                    style: GerenaColors.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDateField('01/04/1987'),
                  
                  const SizedBox(height: 20),
                  
                  // Método de pago
                  Text(
                    'MÉTODO DE PAGO',
                    style: GerenaColors.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPaymentMethod(),
                  
                  const SizedBox(height: 20),
                  
                  // Dirección de entrega
                  Text(
                    'DIRECCIÓN DE ENTREGA',
                    style: GerenaColors.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Dirección principal seleccionada
                  _buildAddressOption(
                    name: 'Juan Pedro Gonzalez Perez +52 3333303333',
                    address: 'Col. Providencia, Av. Lorem ipsum #3050, Guadalajara, Jalisco, México.',
                    isSelected: true,
                    hasEditIcon: true,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Dirección alternativa
                  _buildAddressOption(
                    name: 'En sucursal',
                    address: 'Col. Lorem ipsum Av. Lorem ipsum #3050, Guadalajara, Jalisco, México.',
                    isSelected: false,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Opciones finales
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CONFIRMACIÓN PREVIA AL ENVÍO',
                              style: GerenaColors.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDropdownField('Si'),
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
                              style: GerenaColors.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDropdownField('Si'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botón programar pedido
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 160,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Programar pedido');
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GerenaColors.secondaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'PROGRAMAR PEDIDO',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? GerenaColors.secondaryColor : Colors.white,
        border: Border.all(
          color: isSelected ? GerenaColors.secondaryColor : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(20),
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextFormField(
        initialValue: date,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        value: 'VISA 5545 15****** 9965',
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey[600],
          size: 18,
        ),
        style: const TextStyle(fontSize: 13, color: Colors.black),
        items: const [
          DropdownMenuItem(
            value: 'VISA 5545 15****** 9965',
            child: Text('VISA 5545 15****** 9965'),
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
          // Checkbox
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
          
          // Información de dirección
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
          
          // Icono de editar (solo para la dirección seleccionada)
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
        value: value,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey[600],
          size: 16,
        ),
        style: const TextStyle(fontSize: 11, color: Colors.black),
        items: [
          DropdownMenuItem(value: 'Si', child: Text(value)),
          DropdownMenuItem(value: 'No', child: Text('No')),
        ],
        onChanged: (newValue) {},
      ),
    );
  }

  // Método estático para mostrar el modal
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