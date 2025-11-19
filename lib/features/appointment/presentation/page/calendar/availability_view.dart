import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/appointment/presentation/page/calendar/availability_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
class AvailabilityView extends GetView<AvailabilityController> {
  const AvailabilityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorFondo,
      appBar: AppBar(
        backgroundColor: GerenaColors.primaryColor,
        title: Text(
          'Gestionar Disponibilidad',
          style: GerenaColors.navbarText,
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                GerenaColors.primaryColor,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(GerenaColors.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de agregar nueva disponibilidad
              _buildAddAvailabilitySection(),
              
              const SizedBox(height: GerenaColors.paddingLarge),
              
              // Lista de disponibilidades existentes
              _buildAvailabilityList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAddAvailabilitySection() {
    return Container(
      padding: const EdgeInsets.all(GerenaColors.paddingMedium),
      decoration: GerenaColors.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agregar Nueva Disponibilidad',
            style: GerenaColors.headingMedium,
          ),
          const SizedBox(height: GerenaColors.paddingMedium),
          
          // Selector de día
          Text(
            'Día de la semana',
            style: GerenaColors.bodyMedium,
          ),
          const SizedBox(height: 8),
          _buildDaySelector(),
          
          const SizedBox(height: GerenaColors.paddingMedium),
          
          // Selectores de hora
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hora de inicio',
                      style: GerenaColors.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildTimeSelector(
                      times: controller.availableTimes,
                      selectedTime: controller.selectedStartTime,
                      onSelected: controller.selectStartTime,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: GerenaColors.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hora de fin',
                      style: GerenaColors.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Obx(() => _buildTimeSelector(
                      times: controller.getAvailableEndTimes(),
                      selectedTime: controller.selectedEndTime,
                      onSelected: controller.selectEndTime,
                    )),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: GerenaColors.paddingLarge),
          
          // Botones de acción
          Row(
            children: [
              Expanded(
                child: GerenaColors.createPrimaryButton(
                  text: 'Agregar',
                  onPressed: controller.addAvailability,
                  isFullWidth: true,
                  height: 45,
                ),
              ),
              const SizedBox(width: GerenaColors.paddingMedium),
              Expanded(
                child: GerenaColors.createSecondaryButton(
                  text: 'Limpiar',
                  onPressed: controller.clearSelection,
                  isFullWidth: true,
                  height: 45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(
          controller.daysOfWeek.length,
          (index) {
            final day = controller.daysOfWeek[index];
            final date = DateTime.now().add(Duration(days: index));
            final isSelected = controller.selectedDay.value?.weekday == date.weekday;
            
            return InkWell(
              onTap: () => controller.selectDay(date),
              borderRadius: GerenaColors.smallBorderRadius,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? GerenaColors.secondaryColor 
                    : GerenaColors.backgroundColor,
                  borderRadius: GerenaColors.smallBorderRadius,
                  border: Border.all(
                    color: isSelected 
                      ? GerenaColors.secondaryColor 
                      : GerenaColors.dividerColor,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  day,
                  style: GoogleFonts.rubik(
                    color: isSelected 
                      ? GerenaColors.textLightColor 
                      : GerenaColors.textPrimaryColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildTimeSelector({
    required List<String> times,
    required Rx<String?> selectedTime,
    required Function(String) onSelected,
  }) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: GerenaColors.backgroundColor,
          borderRadius: GerenaColors.smallBorderRadius,
          border: Border.all(
            color: GerenaColors.dividerColor,
            width: 1,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedTime.value,
            hint: Text(
              'Seleccionar hora',
              style: GoogleFonts.rubik(
                color: GerenaColors.textSecondaryColor,
                fontSize: 14,
              ),
            ),
            icon: Icon(
              Icons.access_time,
              color: GerenaColors.primaryColor,
            ),
            dropdownColor: GerenaColors.backgroundColor,
            items: times.isEmpty 
              ? [
                  DropdownMenuItem<String>(
                    value: null,
                    enabled: false,
                    child: Text(
                      'No disponible',
                      style: GoogleFonts.rubik(
                        color: GerenaColors.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  )
                ]
              : times.map((time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(
                      time,
                      style: GoogleFonts.rubik(
                        color: GerenaColors.textPrimaryColor,
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: times.isEmpty ? null : (value) {
              if (value != null) {
                onSelected(value);
              }
            },
          ),
        ),
      );
    });
  }

  Widget _buildAvailabilityList() {
    return Container(
      padding: const EdgeInsets.all(GerenaColors.paddingMedium),
      decoration: GerenaColors.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disponibilidad Actual',
            style: GerenaColors.headingMedium,
          ),
          const SizedBox(height: GerenaColors.paddingMedium),
          
          Obx(() {
            if (controller.availabilities.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(GerenaColors.paddingLarge),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: GerenaColors.textSecondaryColor,
                      ),
                      const SizedBox(height: GerenaColors.paddingMedium),
                      Text(
                        'No hay disponibilidad registrada',
                        style: GerenaColors.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.availabilities.length,
              separatorBuilder: (context, index) => Divider(
                color: GerenaColors.dividerColor,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final availability = controller.availabilities[index];
                return _buildAvailabilityItem(availability);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAvailabilityItem(availability) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: GerenaColors.paddingMedium,
        horizontal: GerenaColors.paddingSmall,
      ),
      child: Row(
        children: [
          // Icono del día
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: GerenaColors.backgroundCalendar,
              borderRadius: GerenaColors.smallBorderRadius,
            ),
            child: Icon(
              Icons.calendar_today,
              color: GerenaColors.textLightColor,
              size: 24,
            ),
          ),
          
          const SizedBox(width: GerenaColors.paddingMedium),
          
          // Información del día y horario
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  availability.diaSemana ?? 'Sin día',
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: GerenaColors.textSecondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${availability.horaInicio ?? ''} - ${availability.horaFin ?? ''}',
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        color: GerenaColors.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Botón de eliminar
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: GerenaColors.errorColor,
            ),
            onPressed: () {
              _showDeleteConfirmation(availability.id);
            },
            tooltip: 'Eliminar disponibilidad',
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(int? id) {
    if (id == null) return;
    
    Get.dialog(
      AlertDialog(
        backgroundColor: GerenaColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: GerenaColors.mediumBorderRadius,
        ),
        title: Text(
          '¿Eliminar disponibilidad?',
          style: GerenaColors.headingSmall,
        ),
        content: Text(
          'Esta acción no se puede deshacer.',
          style: GerenaColors.bodyMedium,
        ),
        actions: [
          GerenaColors.createSecondaryButton(
            text: 'Cancelar',
            onPressed: () => Get.back(),
            height: 40,
          ),
          const SizedBox(width: 8),
          GerenaColors.widgetButton(
            text: 'Eliminar',
            backgroundColor: GerenaColors.errorColor,
            onPressed: () {
              Get.back();
              controller.removeAvailability(id);
            },
          ),
        ],
      ),
    );
  }
}