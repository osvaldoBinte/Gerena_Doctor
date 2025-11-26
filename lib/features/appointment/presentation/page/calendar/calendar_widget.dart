import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/modal_agregar_cita.dart';
import 'package:gerena/features/appointment/presentation/page/calendar/availability_controller.dart';
import 'package:gerena/features/home/dashboard/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'calendar_controller.dart';

class CalendarWidget extends StatefulWidget {
  final Function(DateTime)? onDateSelected;

  const CalendarWidget({
    Key? key,
    this.onDateSelected,
  }) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime? _lastTappedDate;
  int _tapCount = 0;
  late ScrollController _scrollController;

  late CalendarControllerGetx calendarController =
      Get.find<CalendarControllerGetx>();
  late DashboardController dashboardController =
      Get.find<DashboardController>();
  late AvailabilityController availabilityController =
      Get.find<AvailabilityController>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - 120;

    return Scaffold(
          appBar: GetPlatform.isMobile
    ? AppBar(
        backgroundColor: GerenaColors.backgroundColorFondo,
        elevation: 4,
        shadowColor: GerenaColors.shadowColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: GerenaColors.textPrimaryColor,
          ),
          onPressed: () {
                                      Get.offAllNamed(RoutesNames.homePage);

          },
        ),
        title: Text(
          'Calendario ',
          style: GerenaColors.headingMedium.copyWith(fontSize: 18),
        ),
      )
          : null,
      body: Container(
        height: availableHeight,
        decoration: BoxDecoration(
          color: GerenaColors.backgroundColorfondo,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con botón de toggle
            _buildCalendarHeaderWithToggle(calendarController),

            // Contenido que cambia según la vista actual
            Expanded(
              child: Obx(() {
                // Vista de disponibilidad
                if (availabilityController.currentView.value ==
                    'availability') {
                  return _buildAvailabilityView();
                }

                // Vista de citas normales
                return Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildCalendarView(),
                    ),
                    Expanded(
                      flex: 3,
                      child: Obx(() => _buildDayAppointments(
                          calendarController, dashboardController)),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildCalendarHeaderWithToggle(CalendarControllerGetx controller) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Detectar si es pantalla pequeña
      final isSmallScreen = constraints.maxWidth < 600;

      return Container(
        height: isSmallScreen ? 140 : 80,
        padding: const EdgeInsets.all(16.0),
        child: isSmallScreen
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Navegación del calendario (arriba) - CORREGIDO
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.chevron_left,
                              color: GerenaColors.primaryColor,
                              size: 40,
                            ),
                            onPressed: controller.previousPeriod,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                controller.getFormattedDate(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 27,
                                  color: GerenaColors.textPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              color: GerenaColors.primaryColor,
                              size: 40,
                            ),
                            onPressed: controller.nextPeriod,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      )),

                  // Botón de toggle (abajo)
                  Obx(() => Container(
                        decoration: BoxDecoration(
                          color: availabilityController.currentView.value ==
                                  'availability'
                              ? GerenaColors.secondaryColor
                              : GerenaColors.primaryColor,
                          borderRadius: GerenaColors.smallBorderRadius,
                          boxShadow: [GerenaColors.lightShadow],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              availabilityController.toggleView();
                            },
                            borderRadius: GerenaColors.smallBorderRadius,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    availabilityController
                                                .currentView.value ==
                                            'availability'
                                        ? Icons.calendar_month
                                        : Icons.schedule,
                                    color: GerenaColors.textLightColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    availabilityController
                                                .currentView.value ==
                                            'availability'
                                        ? 'Citas'
                                        : 'Disponibilidad',
                                    style: GoogleFonts.rubik(
                                      color: GerenaColors.textLightColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Navegación del calendario - TAMBIÉN CORREGIDO PARA DESKTOP
                  Obx(() => Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.chevron_left,
                              color: GerenaColors.primaryColor,
                              size: 40,
                            ),
                            onPressed: controller.previousPeriod,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          SizedBox(width: 18),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              controller.getFormattedDate(),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 27,
                                color: GerenaColors.textPrimaryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 18),
                          IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              color: GerenaColors.primaryColor,
                              size: 40,
                            ),
                            onPressed: controller.nextPeriod,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      )),

                  // Botón de toggle
                  Obx(() => Container(
                        decoration: BoxDecoration(
                          color: availabilityController.currentView.value ==
                                  'availability'
                              ? GerenaColors.secondaryColor
                              : GerenaColors.primaryColor,
                          borderRadius: GerenaColors.smallBorderRadius,
                          boxShadow: [GerenaColors.lightShadow],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              availabilityController.toggleView();
                            },
                            borderRadius: GerenaColors.smallBorderRadius,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    availabilityController
                                                .currentView.value ==
                                            'availability'
                                        ? Icons.calendar_month
                                        : Icons.schedule,
                                    color: GerenaColors.textLightColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    availabilityController
                                                .currentView.value ==
                                            'availability'
                                        ? 'Citas'
                                        : 'Disponibilidad',
                                    style: GoogleFonts.rubik(
                                      color: GerenaColors.textLightColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
      );
    },
  );
}

  Widget _buildAvailabilityView() {
    return Container(
      color: GerenaColors.backgroundColorFondo,
      child: SingleChildScrollView(
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
      ),
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
                      times: availabilityController.availableTimes,
                      selectedTime: availabilityController.selectedStartTime,
                      onSelected: availabilityController.selectStartTime,
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
                          times: availabilityController.getAvailableEndTimes(),
                          selectedTime: availabilityController.selectedEndTime,
                          onSelected: availabilityController.selectEndTime,
                        )),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: GerenaColors.paddingLarge),

          // Botones de acción
          Obx(() => Row(
                children: [
                  Expanded(
                    child: GerenaColors.widgetButton(
                      text: 'AGREGAR',
                      onPressed: availabilityController.addAvailability,
                      isLoading: availabilityController.isLoading.value,
                      backgroundColor: GerenaColors.secondaryColor,
                      fontSize: 14,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: GerenaColors.paddingMedium),
                  Expanded(
                    child: GerenaColors.widgetButton(
                      text: 'LIMPIAR',
                      onPressed: availabilityController.clearSelection,
                      backgroundColor: GerenaColors.colorCancelar,
                      textColor: GerenaColors.textPrimaryColor,
                      fontSize: 14,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      showShadow: false,
                    ),
                  ),
                ],
              )),
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
          availabilityController.daysOfWeek.length,
          (index) {
            final day = availabilityController.daysOfWeek[index];
            final date = DateTime.now().add(Duration(days: index));
            final isSelected =
                availabilityController.selectedDay.value?.weekday ==
                    date.weekday;

            return InkWell(
              onTap: () => availabilityController.selectDay(date),
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
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
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
            onChanged: times.isEmpty
                ? null
                : (value) {
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
            if (availabilityController.isLoading.value) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(GerenaColors.paddingLarge),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      GerenaColors.primaryColor,
                    ),
                  ),
                ),
              );
            }

            if (availabilityController.availabilities.isEmpty) {
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
              itemCount: availabilityController.availabilities.length,
              separatorBuilder: (context, index) => Divider(
                color: GerenaColors.dividerColor,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final availability =
                    availabilityController.availabilities[index];
                return _buildAvailabilityItem(availability);
              },
            );
          }),
        ],
      ),
    );
  }

  // Helper method para extraer propiedades de manera segura
  String _getProperty(
      dynamic obj, List<String> possibleNames, String defaultValue) {
    for (var name in possibleNames) {
      try {
        final value = (obj as dynamic);
        switch (name) {
          case 'diaSemana':
            return value.diaSemana ?? defaultValue;
          case 'dayOfWeek':
            return value.dayOfWeek ?? defaultValue;
          case 'horaInicio':
            return value.horaInicio ?? defaultValue;
          case 'startTime':
            return value.startTime ?? defaultValue;
          case 'horaFin':
            return value.horaFin ?? defaultValue;
          case 'endTime':
            return value.endTime ?? defaultValue;
        }
      } catch (e) {
        continue;
      }
    }
    return defaultValue;
  }

  int? _getId(dynamic obj) {
    try {
      return (obj as dynamic).id;
    } catch (e) {
      return null;
    }
  }

  Widget _buildAvailabilityItem(dynamic availability) {
    final dayOfWeek =
        _getProperty(availability, ['diaSemana', 'dayOfWeek'], 'Sin día');
    final startTime =
        _getProperty(availability, ['horaInicio', 'startTime'], '--:--');
    final endTime = _getProperty(availability, ['horaFin', 'endTime'], '--:--');
    final id = _getId(availability);

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
                  dayOfWeek,
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
                      '$startTime - $endTime',
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
              if (id != null) {
                _showDeleteConfirmation(id);
              }
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
          GerenaColors.widgetButton(
            text: 'CANCELAR',
            onPressed: () => Get.back(),
            backgroundColor: GerenaColors.colorCancelar,
            textColor: GerenaColors.textPrimaryColor,
            showShadow: false,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          const SizedBox(width: 8),
          GerenaColors.widgetButton(
            text: 'ELIMINAR',
            backgroundColor: GerenaColors.errorColor,
            onPressed: () {
              Get.back();
              availabilityController.removeAvailability(id);
            },
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Obx(() {
      if (kDebugMode) {
        print('Total de citas: ${calendarController.appointments.length}');
        for (var appt in calendarController.appointments) {
          print('Cita: ${appt.subject} - ${appt.startTime} - ${appt.endTime}');
        }
      }

      return Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: -1,
              right: -1,
              top: -1,
              bottom: -1,
              child: SfCalendar(
                view: CalendarView.month,
                controller: calendarController.calendarController,
                dataSource:
                    _getCalendarDataSource(calendarController.appointments),
                initialDisplayDate: calendarController.selectedDate.value,
                initialSelectedDate: calendarController.selectedDate.value,
                showNavigationArrow: false,
                headerHeight: 0,
                viewHeaderHeight: 40,
                selectionDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.transparent),
                ),
                onViewChanged: (ViewChangedDetails details) {
                  if (details.visibleDates.isNotEmpty && mounted) {
                    final newFocusDate =
                        details.visibleDates[details.visibleDates.length ~/ 2];
                    print('Fecha enfocada cambiada a: $newFocusDate');

                    if (calendarController.focusedDate.value.month !=
                            newFocusDate.month ||
                        calendarController.focusedDate.value.year !=
                            newFocusDate.year) {
                      calendarController.focusedDate.value = newFocusDate;

                      final firstDayOfMonth =
                          DateTime(newFocusDate.year, newFocusDate.month, 1);
                      calendarController
                          .loadAppointmentsForDate(firstDayOfMonth);

                      print(
                          'Cargando citas para el mes: ${newFocusDate.month}/${newFocusDate.year}');
                    }
                  }
                },
                monthViewSettings: MonthViewSettings(
                  showAgenda: false,
                  appointmentDisplayMode: MonthAppointmentDisplayMode.none,
                  appointmentDisplayCount: 3,
                  monthCellStyle: MonthCellStyle(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.transparent,
                    ),
                    trailingDatesTextStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.transparent,
                    ),
                    leadingDatesTextStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.transparent,
                    ),
                    todayBackgroundColor: Colors.transparent,
                    todayTextStyle: TextStyle(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                viewHeaderStyle: ViewHeaderStyle(
                  dayTextStyle: GoogleFonts.rubik(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
                monthCellBuilder:
                    (BuildContext context, MonthCellDetails details) {
                  return _buildCalendarCell(details);
                },
                onTap: (CalendarTapDetails details) {
                  if (!mounted) return;

                  if (details.targetElement == CalendarElement.calendarCell) {
                    if (details.date != null) {
                      _handleDateTap(details.date!, calendarController,
                          dashboardController);

                      if (widget.onDateSelected != null) {
                        widget.onDateSelected!(details.date!);
                      }
                    }
                  } else if (details.targetElement ==
                      CalendarElement.appointment) {
                    if (details.date != null) {
                      _handleDateTap(details.date!, calendarController,
                          dashboardController);
                    }
                  }
                },
                appointmentBuilder:
                    (BuildContext context, CalendarAppointmentDetails details) {
                  return Container();
                },
              ),
            ),
            ..._buildBorderOverlays(),
          ],
        ),
      );
    });
  }

  Widget _buildCustomWeekDayHeader() {
    final weekDays = ['D', 'L', 'M', 'M', 'J', 'V', 'S'];

    return Row(
      children: weekDays.map((day) {
        return Expanded(
          child: Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              day,
              style: GoogleFonts.rubik(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: GerenaColors.textPrimaryColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarCell(MonthCellDetails details) {
    final isCurrentMonth = details.date.month ==
        details.visibleDates[details.visibleDates.length ~/ 2].month;
    final hasAppointments =
        calendarController.getAppointmentsForDate(details.date).isNotEmpty;
    final isSelected = calendarController.selectedDate.value != null &&
        details.date.day == calendarController.selectedDate.value!.day &&
        details.date.month == calendarController.selectedDate.value!.month &&
        details.date.year == calendarController.selectedDate.value!.year;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: GerenaColors.backgroundcalendart,
          width: 0.5,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            left: 6,
            child: Container(
              width: 24,
              height: 24,
              decoration: isSelected
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: GerenaColors.primaryColor,
                        width: 2,
                      ),
                    )
                  : null,
              child: Center(
                child: Text(
                  '${details.date.day}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isCurrentMonth
                        ? GerenaColors.textPrimaryColor
                        : Colors.transparent,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          if (isCurrentMonth && hasAppointments)
            ..._buildAppointmentIndicators(details.date),
        ],
      ),
    );
  }

  List<Widget> _buildAppointmentIndicators(DateTime date) {
    final appointments = calendarController.getAppointmentsForDate(date);

    return [
      Positioned(
        top: 32,
        left: 2,
        right: 2,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: GerenaColors.backgroundcalendart,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            appointments.first.subject,
            style: TextStyle(
              fontSize: 8,
              color: GerenaColors.textLightColor,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      if (appointments.length > 1)
        Positioned(
          bottom: 4,
          left: 0,
          right: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: GerenaColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 2),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: GerenaColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 2),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: GerenaColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
    ];
  }

  List<Widget> _buildBorderOverlays() {
    return [
      Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        width: 1,
        child: Container(color: GerenaColors.backgroundColorfondo),
      ),
      Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        width: 1,
        child: Container(color: GerenaColors.backgroundColorfondo),
      ),
      Positioned(
        left: 0,
        right: 0,
        top: 0,
        height: 1,
        child: Container(color: GerenaColors.backgroundColorfondo),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        height: 1,
        child: Container(color: GerenaColors.backgroundColorfondo),
      ),
    ];
  }

  void _handleDateTap(
      DateTime tappedDate,
      CalendarControllerGetx calendarController,
      DashboardController dashboardController) {
    if (_lastTappedDate != null &&
        _lastTappedDate!.day == tappedDate.day &&
        _lastTappedDate!.month == tappedDate.month &&
        _lastTappedDate!.year == tappedDate.year) {
      _tapCount++;

      if (_tapCount == 2) {
        print('Doble tap detectado en: $tappedDate');

        final appointmentsForDay =
            calendarController.getAppointmentsForDate(tappedDate);
        if (appointmentsForDay.isNotEmpty) {
          dashboardController.showMedicalAppointments(
              tappedDate, appointmentsForDay);
        }

        _tapCount = 0;
        _lastTappedDate = null;
        return;
      }
    } else {
      _tapCount = 1;
    }

    calendarController.selectedDate.value = tappedDate;
    _lastTappedDate = tappedDate;

    Future.delayed(const Duration(milliseconds: 500), () {
      _tapCount = 0;
      _lastTappedDate = null;
    });
  }

  CalendarDataSource _getCalendarDataSource(List<Appointment> appointments) {
    final List<Appointment> meetings = <Appointment>[];

    for (var appointment in appointments) {
      meetings.add(Appointment(
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        subject: appointment.subject,
        color: appointment.color,
        notes: appointment.notes,
        location: appointment.location,
        isAllDay: false,
      ));
    }

    return _AppointmentDataSource(meetings);
  }

  void _scrollToIndex(int index) {
    if (_scrollController.hasClients) {
      double itemHeight = 100.0;
      double targetOffset = index * itemHeight;

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    calendarController.updateCurrentAppointmentIndex(index);
  }

  Widget _buildDayAppointments(CalendarControllerGetx controller,
      DashboardController dashboardController) {
    if (controller.selectedDate.value == null) {
      return const Center(child: SizedBox.shrink());
    }

    final appointmentsForDay =
        controller.getAppointmentsForDate(controller.selectedDate.value!);

    // Cuando NO hay citas
    if (appointmentsForDay.isEmpty) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: GerenaColors.smallBorderRadius,
                ),
                child: Text(
                  'No hay citas para el ${controller.formatSelectedDate(controller.selectedDate.value!)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: GerenaColors.textSecondaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
          // Botón flotante cuando NO hay citas
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: GerenaColors.textPrimaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: GerenaColors.textLightColor,
                  size: 40,
                ),
                onPressed: () {
                  // Abrir el modal
                  ModalAgregarCita.show(
                    clienteId: 123, // Reemplaza con el ID real del cliente
                    doctorId: 456, // Reemplaza con el ID real del doctor
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    // Cuando hay UNA sola cita
    if (appointmentsForDay.length == 1) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: buildAppointmentCard(
                appointmentsForDay[0], controller, dashboardController),
          ),
          // Botón flotante cuando hay UNA cita
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: GerenaColors.textPrimaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: GerenaColors.textLightColor,
                  size: 40,
                ),
                onPressed: () {
                  // Abrir el modal
                  ModalAgregarCita.show(
                    clienteId: 123, // Reemplaza con el ID real del cliente
                    doctorId: 456, // Reemplaza con el ID real del doctor
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    // Cuando hay MÚLTIPLES citas
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    appointmentsForDay.length,
                    (index) => _buildCircleIndicator(index, controller),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: appointmentsForDay.length,
                  itemBuilder: (context, index) {
                    return buildAppointmentCard(appointmentsForDay[index],
                        controller, dashboardController);
                  },
                ),
              ),
            ],
          ),
        ),
        // Botón flotante cuando hay MÚLTIPLES citas
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: GerenaColors.textPrimaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.add,
                color: GerenaColors.textLightColor,
                size: 40,
              ),
              onPressed: () {
                // Abrir el modal
                ModalAgregarCita.show(
                  clienteId: 123, // Reemplaza con el ID real del cliente
                  doctorId: 456, // Reemplaza con el ID real del doctor
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleIndicator(int index, CalendarControllerGetx controller) {
    return Obx(() {
      final isActive = index == controller.currentAppointmentIndex.value;

      return GestureDetector(
        onTap: () {
          _scrollToIndex(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 4),
          width: isActive ? 12 : 8,
          height: isActive ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? GerenaColors.colorHoverRow : Colors.white,
            border: Border.all(
              color: isActive ? GerenaColors.colorHoverRow : Colors.grey[300]!,
              width: isActive ? 2 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: GerenaColors.colorHoverRow.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        ),
      );
    });
  }

  Widget buildAppointmentCard(
      Appointment appointment,
      CalendarControllerGetx controller,
      DashboardController dashboardController) {
    final hour = appointment.startTime.hour;
    final minute = appointment.startTime.minute;
    final period = hour < 12 ? 'A.M.' : 'P.M.';
    final formattedHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final formattedTime =
        '$formattedHour:${minute.toString().padLeft(2, '0')} $period';
    final formattedDate = DateFormat('d \'de\' MMMM \'de\' yyyy', 'es_ES')
        .format(appointment.startTime);

    String tipoVisita = 'Seguimiento';
    if (appointment.location != null && appointment.location!.isNotEmpty) {
      tipoVisita = appointment.location!;
    }

    String procedimiento = 'Procedimiento no especificado';
    if (appointment.notes != null && appointment.notes!.isNotEmpty) {
      procedimiento = appointment.notes!;
    }

    return GestureDetector(
      onTap: () {
        final appointmentsForDay =
            controller.getAppointmentsForDate(appointment.startTime);
        dashboardController.showMedicalAppointments(
            appointment.startTime, appointmentsForDay);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [GerenaColors.lightShadow],
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: _buildDefaultAvatar(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      appointment.subject,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: GerenaColors.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tipoVisita,
                      style: TextStyle(
                        fontSize: 12,
                        color: GerenaColors.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      procedimiento,
                      style: TextStyle(
                        fontSize: 12,
                        color: GerenaColors.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 11,
                      color: GerenaColors.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 11,
                        color: GerenaColors.textSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      child: Image.asset(
        'assets/icons/FOTOGRAFIA.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].subject;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String? getNotes(int index) {
    return appointments![index].notes;
  }

  @override
  String? getLocation(int index) {
    return appointments![index].location;
  }
}
