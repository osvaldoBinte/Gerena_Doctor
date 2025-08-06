import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class Facturacion extends StatelessWidget {
  const Facturacion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const  EdgeInsets.symmetric(horizontal: 50.0),

      child: SingleChildScrollView(
        child: Center(
          child: Container(
                  color: GerenaColors.backgroundColor,

            child: Card(
              elevation: GerenaColors.elevationSmall,
              shape: RoundedRectangleBorder(
                borderRadius: GerenaColors.mediumBorderRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título principal
                    Text(
                      'Detalles de compra',
                      style: GerenaColors.headingMedium.copyWith(fontSize: 18),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Sección de detalles de compra
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: 'No. de Folio',
                            hasDropdown: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField(
                            label: 'Cantidad',
                            placeholder: '000',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField(
                            label: 'Total',
                            placeholder: '\$000MXN',
                            isReadOnly: true,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Título de facturación
                    Text(
                      'Agrega los datos de facturación',
                      style: GerenaColors.headingMedium.copyWith(fontSize: 18),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Primera fila - RFC y Código Postal
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(label: 'RFC'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField(label: 'Código Postal'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Segunda fila - Nombre/Razón Social
                    _buildInputField(label: 'Nombre / Razón Social'),
                    
                    const SizedBox(height: 16),
                    
                    // Tercera fila - Régimen Fiscal y Uso de CFDI
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(label: 'Régimen Fiscal'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(label: 'Uso de CFDI'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Cuarta fila - Correo electrónico
                    _buildInputField(label: 'Correo electrónico'),
                    
                    const SizedBox(height: 16),
                    
                    // Quinta fila - Dirección de facturación
                    _buildInputField(label: 'Dirección de facturación'),
                    
                    const SizedBox(height: 32),
                    
                    // Botón de facturar
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 120,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            print('Facturar presionado');
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
                            'FACTURAR',
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    String? placeholder,
    bool hasDropdown = false,
    bool isReadOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GerenaColors.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: isReadOnly,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (hasDropdown)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GerenaColors.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            hint: Text(
              'Seleccionar...',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20,
            ),
            items: const [], // Lista vacía por ahora
            onChanged: (value) {
              print('Dropdown seleccionado: $value');
            },
          ),
        ),
      ],
    );
  }
}