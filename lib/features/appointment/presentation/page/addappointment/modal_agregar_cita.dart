import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/add_appointment_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ModalAgregarCita extends StatelessWidget {
  const ModalAgregarCita({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('INFORMACIÓN DEL PACIENTE'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => GerenaColors.buildLabeledTextField(
                                  'Nombres*',
                                  '',
                                  controller: controller.nombresController,
                                  hintText: 'Juan Pedro',
                                  errorText: 'El nombre es requerido',
                                  showError:
                                      controller.nombresError.value.isNotEmpty,
                                )),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() => GerenaColors.buildLabeledTextField(
                                  'Apellidos*',
                                  '',
                                  controller: controller.apellidosController,
                                  hintText: 'González Pérez',
                                  errorText: 'Los apellidos son requeridos',
                                  showError: controller
                                      .apellidosError.value.isNotEmpty,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePickerField(
                              context,
                              'Fecha de Nacimiento',
                              controller.fechaNacimientoController,
                              () => controller.selectBirthDate(context),
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

                      const SizedBox(height: 24),

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

                      _buildSectionTitle('DETALLES DE LA CITA'),
                      const SizedBox(height: 12),
                      Obx(() => _buildDropdown(
                            'Tipo de Cita*',
                            controller.selectedTipoCita.value,
                            controller.tiposCitaDisplay,
                            (value) {
                              controller.selectedTipoCita.value = value;
                              controller.tipoCitaError.value =
                                  ''; 
                            },
                            errorText: 'Selecciona un tipo de cita',
                            showError:
                                controller.tipoCitaError.value.isNotEmpty,
                          )),
                      const SizedBox(height: 12),
                      GerenaColors.buildLabeledTextField(
                        'Motivo de la Consulta',
                        '',
                        controller: controller.motivoController,
                        hintText: 'Describe el motivo de tu consulta...',
                      ),

                      const SizedBox(height: 24),

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
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    color: Colors.grey[600]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'No hay horarios disponibles en los próximos días',
                                    style: GoogleFonts.rubik(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FECHA',
                              style: GerenaColors.headingSmall.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: controller.availability.map((date) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Obx(() {
                                      final isSelected =
                                          controller.selectedDate.value == date;
                                      return _buildDateOption(
                                        date.diaNombre,
                                        date.fecha,
                                        isSelected,
                                        () => controller.selectDate(date),
                                      );
                                    }),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
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
                                        .selectedDate.value!.timeSlots
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

                      _buildSectionTitle('COMENTARIOS ADICIONALES'),
                      const SizedBox(height: 12),
                      GerenaColors.buildLabeledTextField(
                        'Comentarios',
                        '',
                        controller: controller.comentariosController,
                        hintText: 'Información adicional relevante...',
                      ),

                      const SizedBox(height: 24),

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

  Widget _buildDatePickerField(
    BuildContext context,
    String label,
    TextEditingController controller,
    VoidCallback onTap,
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
        TextField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          style: GoogleFonts.rubik(
            fontSize: 14,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Selecciona una fecha',
            hintStyle: GoogleFonts.rubik(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            suffixIcon: Icon(
              Icons.calendar_today,
              color: GerenaColors.primaryColor,
              size: 18,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: GerenaColors.colorinput),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: GerenaColors.colorinput),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }

  String _formatDisplayDate(String date) {
    if (date.isEmpty) return '';

    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
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

  Widget _buildDropdown(String label, String? value, List<String> items,
      Function(String?) onChanged,
      {String? errorText, bool showError = false}) {
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
          height: showError ? null : 40,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              errorText: showError ? errorText : null,
              errorStyle: GoogleFonts.rubik(
                color: GerenaColors.errorColor,
                fontSize: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: showError
                      ? GerenaColors.errorColor
                      : GerenaColors.colorinput,
                  width: showError ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: showError
                      ? GerenaColors.errorColor
                      : GerenaColors.colorinput,
                  width: showError ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.zero,
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: GerenaColors.errorColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.zero,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: GerenaColors.errorColor,
                  width: 1.5,
                ),
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
            color: isSelected ? GerenaColors.secondaryColor : Colors.grey[300]!,
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
                color:
                    isSelected ? Colors.white : GerenaColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: GoogleFonts.rubik(
                fontSize: 11,
                color:
                    isSelected ? Colors.white : GerenaColors.textSecondaryColor,
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
            color: isSelected ? GerenaColors.secondaryColor : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: GoogleFonts.rubik(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : GerenaColors.textPrimaryColor,
          ),
        ),
      ),
    );
  }

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
