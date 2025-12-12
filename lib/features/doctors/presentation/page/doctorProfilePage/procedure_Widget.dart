import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ProcedureWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String? authorName;
  final bool isFullView;
  final VoidCallback? onContinueReading;
  final VoidCallback? onClose; // Nuevo parámetro para el botón cerrar

  const ProcedureWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.authorName,
    this.isFullView = false,
    this.onContinueReading,
    this.onClose, // Agregar este parámetro
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: isFullView ? [] : [GerenaColors.mediumShadow],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título, autor y botón cerrar alineados
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lado izquierdo: Título y autor
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (authorName != null && authorName!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$authorName',
                         style: GoogleFonts.rubik(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: GerenaColors.primaryColor,
              ),
                      ),
                    ],
                    Text(
                      title,
                      style: GoogleFonts.rubik(
                        fontSize: isFullView ? 16 : 12,
                        fontWeight: FontWeight.w600,
                        color: GerenaColors.textSecondary,
                      ),
                      maxLines: isFullView ? null : 2,
                      overflow: isFullView ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                   
                   
                  ],
                ),
              ),
              
              // Lado derecho: Botón cerrar (solo en vista completa)
              if (isFullView && onClose != null) ...[
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onClose,
                  child: Image.asset(
                    'assets/icons/close.png',
                    width: 20,
                    height: 20,
                    color: GerenaColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Descripción
          Text(
            description,
            style: GoogleFonts.rubik(
              color: GerenaColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w200,
            ),
            maxLines: isFullView ? null : 6,
            overflow: isFullView ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          
          // Imagen en vista completa (abajo)
          if (isFullView) ...[
            const SizedBox(height: 16),
            Center(
              child: ClipRRect(
                borderRadius: GerenaColors.smallBorderRadius,
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          
          // Vista resumida
          if (!isFullView) ...[
            const SizedBox(height: 4),
            GestureDetector(
              onTap: onContinueReading,
              child: Text(
                'Continuar leyendo',
                style: GoogleFonts.rubik(
                  fontSize: 14,
                  color: GerenaColors.seepublication,
                  fontWeight: FontWeight.w200,
                  decoration: TextDecoration.underline,
                  decorationColor: GerenaColors.seepublication,
                  decorationThickness: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
              child: Image.asset(imagePath),
            ),
          ],
        ],
      ),
    );
  }
}