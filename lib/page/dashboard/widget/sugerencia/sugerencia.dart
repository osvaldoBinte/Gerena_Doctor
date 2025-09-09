import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class Sugerencia extends StatelessWidget {
  const Sugerencia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
                padding:const  EdgeInsets.symmetric(horizontal: 60.0),

      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            child: Card(
              elevation: GerenaColors.elevationSmall,
              shape: RoundedRectangleBorder(
                borderRadius: GerenaColors.mediumBorderRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comparte tus sugerencias',
                      style: GerenaColors.headingMedium.copyWith(fontSize: 18),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildInputField(
                      label: 'Correo electrónico',
                      placeholder: 'username@example.com',
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(label: 'Nombre/s*'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField(label: 'Apellidos*'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildInputField(label: 'Título'),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextAreaField(label: 'Descripción'),
                    
                    const SizedBox(height: 24),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            print('Sugerencia enviada');
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
                            'ENVIAR',
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
          child: TextFormField(
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
      ],
    );
  }

  Widget _buildTextAreaField({required String label}) {
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
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextFormField(
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}