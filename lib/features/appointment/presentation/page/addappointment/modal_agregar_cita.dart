import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/add_appointment_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ModalAgregarCita extends StatelessWidget {
  const ModalAgregarCita({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
    
    // Obtener controller
    final controller = Get.find<AddAppointmentController>();


    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 900),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
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
                    'AGENDAR CITA MÉDICA',
                    style: GerenaColors.headingSmall.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.clearForm();
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sección: Información del Paciente
                      _buildSectionTitle('INFORMACIÓN DEL PACIENTE'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GerenaColors.buildLabeledTextField(
                              'Nombres*',
                              '',
                              controller: controller.nombresController,
                              hintText: 'Juan Pedro',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GerenaColors.buildLabeledTextField(
                              'Apellidos*',
                              '',
                              controller: controller.apellidosController,
                              hintText: 'González Pérez',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GerenaColors.buildLabeledTextField(
                              'Fecha de Nacimiento',
                              '',
                              controller: controller.fechaNacimientoController,
                              hintText: 'DD/MM/AAAA',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() => _buildDropdown(
                                  'Tipo de Sangre',
                                  controller.selectedTipoSangre.value,
                                  controller.tiposSangre,
                                  (value) {
                                    controller.selectedTipoSangre.value = value;
                                  },
                                )),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Sección: Contacto
                      _buildSectionTitle('CONTACTO'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GerenaColors.buildLabeledTextField(
                              'Correo Electrónico',
                              '',
                              controller: controller.correoController,
                              hintText: 'correo@ejemplo.com',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GerenaColors.buildLabeledTextField(
                              'Teléfono',
                              '',
                              controller: controller.telefonoController,
                              hintText: '+52 333 330 3333',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Sección: Dirección
                      _buildSectionTitle('DIRECCIÓN'),
                      const SizedBox(height: 12),
                      GerenaColors.buildLabeledTextField(
                        'Calle y Número',
                        '',
                        controller: controller.direccionController,
                        hintText: 'Av. López Mateos #3050',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GerenaColors.buildLabeledTextField(
                              'Colonia',
                              '',
                              controller: controller.coloniaController,
                              hintText: 'Providencia',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GerenaColors.buildLabeledTextField(
                              'Ciudad',
                              '',
                              controller: controller.ciudadController,
                              hintText: 'Guadalajara',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GerenaColors.buildLabeledTextField(
                              'C.P.',
                              '',
                              controller: controller.codigoPostalController,
                              hintText: '44630',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Sección: Información Médica
                      _buildSectionTitle('INFORMACIÓN MÉDICA'),
                      const SizedBox(height: 12),
                      GerenaColors.buildLabeledTextField(
                        'Alergias',
                        '',
                        controller: controller.alergiasController,
                        hintText: 'Penicilina, polen...',
                      ),
                      const SizedBox(height: 12),
                      GerenaColors.buildLabeledTextField(
                        'Padecimientos Actuales',
                        '',
                        controller: controller.padecimientosController,
                        hintText: 'Hipertensión, diabetes...',
                      ),
                      const SizedBox(height: 12),
                      GerenaColors.buildLabeledTextField(
                        'Enfermedades y Cirugías Previas',
                        '',
                        controller: controller.enfermedadesController,
                        hintText: 'Apendicitis (2015)...',
                      ),
                      const SizedBox(height: 12),
                      GerenaColors.buildLabeledTextField(
                        'Pruebas y Estudios Recientes',
                        '',
                        controller: controller.pruebasController,
                        hintText: 'Análisis de sangre, radiografías...',
                      ),

                      const SizedBox(height: 24),

                      // Sección: Detalles de la Cita
                      _buildSectionTitle('DETALLES DE LA CITA'),
                      const SizedBox(height: 12),
                      Obx(() => _buildDropdown(
                            'Tipo de Cita*',
                            controller.selectedTipoCita.value,
                            controller.tiposCita,
                            (value) {
                              controller.selectedTipoCita.value = value;
                            },
                          )),
                      const SizedBox(height: 12),
                      GerenaColors.buildLabeledTextField(
                        'Motivo de la Consulta',
                        '',
                        controller: controller.motivoController,
                        hintText: 'Describe el motivo de tu consulta...',
                      ),

                      const SizedBox(height: 24),

                      // Sección: Selección de Fecha y Hora
                      _buildSectionTitle('FECHA Y HORA DISPONIBLE'),
                      const SizedBox(height: 12),
                      Obx(() {
                        if (controller.isLoadingAvailability.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (controller.availability.isEmpty) {
                          return Text(
                            'No hay horarios disponibles',
                            style: GoogleFonts.rubik(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Selección de fecha
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: controller.availability.map((date) {
                                return Obx(() {
                                  final isSelected =
                                      controller.selectedDate.value == date;
                                  return _buildDateOption(
                                    date.diaNombre,
                                    date.fecha,
                                    isSelected,
                                    () => controller.selectDate(date),
                                  );
                                });
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            // Selección de hora
                            Obx(() {
                              if (controller.selectedDate.value == null) {
                                return const SizedBox.shrink();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'HORA',
                                    style: GerenaColors.headingSmall.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: controller
                                        .selectedDate.value!.horariosDisponibles
                                        .map((time) {
                                      return Obx(() {
                                        final isSelected =
                                            controller.selectedTime.value ==
                                                time;
                                        return _buildTimeOption(
                                          time.hora,
                                          isSelected,
                                          () => controller.selectTime(time),
                                        );
                                      });
                                    }).toList(),
                                  ),
                                ],
                              );
                            }),
                          ],
                        );
                      }),

                      const SizedBox(height: 24),

                      // Comentarios adicionales
                      _buildSectionTitle('COMENTARIOS ADICIONALES'),
                      const SizedBox(height: 12),
                      GerenaColors.buildLabeledTextField(
                        'Comentarios',
                        '',
                        controller: controller.comentariosController,
                        hintText: 'Información adicional relevante...',
                      ),

                      const SizedBox(height: 24),

                      // Botón de acción
                      Align(
                        alignment: Alignment.centerRight,
                        child: Obx(() {
                          return SizedBox(
                            width: 180,
                            child: controller.isSavingAppointment.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : GerenaColors.widgetButton(
                                    text: 'AGENDAR CITA',
                                    onPressed: () =>
                                        controller.saveAppointment(),
                                    customShadow: GerenaColors.mediumShadow,
                                  ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GerenaColors.headingSmall.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: GerenaColors.textPrimaryColor,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.rubik(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 40,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: GerenaColors.colorinput),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: GerenaColors.colorinput),
                borderRadius: BorderRadius.zero,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 18,
            ),
            style: GoogleFonts.rubik(
              fontSize: 14,
              color: Colors.black,
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDateOption(
    String day,
    String date,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? GerenaColors.secondaryColor : Colors.white,
          border: Border.all(
            color: isSelected
                ? GerenaColors.secondaryColor
                : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: GoogleFonts.rubik(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : GerenaColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: GoogleFonts.rubik(
                fontSize: 11,
                color: isSelected
                    ? Colors.white
                    : GerenaColors.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeOption(
    String time,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? GerenaColors.secondaryColor : Colors.white,
          border: Border.all(
            color: isSelected
                ? GerenaColors.secondaryColor
                : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: GoogleFonts.rubik(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color:
                isSelected ? Colors.white : GerenaColors.textPrimaryColor,
          ),
        ),
      ),
    );
  }

  // Método estático para mostrar el modal con Get.dialog
  static void show({
    required int clienteId,
    required int doctorId,
  }) {
    Get.dialog(
      const ModalAgregarCita(),
      arguments: {
        'clienteId': clienteId,
        'doctorId': doctorId,
      },
      barrierDismissible: true,
    );
  }
}