import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientProfileScreen extends StatelessWidget {
  final dynamic appointment;
  final VoidCallback onClose;
  
  const PatientProfileScreen({
    Key? key,
    required this.appointment,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Card
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top section with name and photo
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.subject ?? 'Sin nombre',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A5F7A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${appointment.id ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.teal[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: onClose,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Appointment info
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            appointment.location ?? 'Tipo de cita',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Procedure and time
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              appointment.notes?.isNotEmpty == true
                                  ? appointment.notes 
                                  : 'Sin motivo especificado',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _formatTime(appointment.startTime),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 1),

                    // Appointment Information
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            'Paciente',
                            appointment.subject ?? 'Sin nombre',
                            'Estado',
                            'Confirmada',
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            'Fecha',
                            _formatDate(appointment.startTime),
                            'Hora',
                            _formatTime(appointment.startTime),
                          ),
                          const SizedBox(height: 16),
                          _buildSingleInfoRow(
                            'Tipo de cita',
                            appointment.location ?? 'N/A',
                          ),
                          if (appointment.notes?.isNotEmpty == true) ...[
                            const SizedBox(height: 16),
                            _buildSingleInfoRow(
                              'Motivo de consulta',
                              appointment.notes ?? '',
                            ),
                          ],
                        ],
                      ),
                    ),

                    const Divider(height: 1),

                    // Appointment Details
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMedicalSection(
                            'ID de Cita',
                            '#${appointment.id ?? 'N/A'}',
                          ),
                          const SizedBox(height: 16),
                          _buildMedicalSection(
                            'Inicio',
                            _formatFullDateTime(appointment.startTime),
                          ),
                          const SizedBox(height: 16),
                          _buildMedicalSection(
                            'Fin',
                            _formatFullDateTime(appointment.endTime),
                          ),
                        ],
                      ),
                    ),

                    /*
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _showCancelDialog(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: Colors.red[400]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                'Cancelar cita',
                                style: TextStyle(
                                  color: Colors.red[400],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _showContactOptions(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal[400],
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Contactar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ), */
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'P.M.' : 'A.M.';
    return '$hour:$minute $period';
  }

  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    return '$day/$month/$year';
  }

  String _formatFullDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'P.M.' : 'A.M.';
    return '$day/$month/$year - $hour:$minute $period';
  }

  void _showCancelDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Cancelar cita'),
        content: const Text('¿Estás seguro de que deseas cancelar esta cita?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Cita cancelada',
                'La cita ha sido cancelada exitosamente',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }

  void _showContactOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Contactar paciente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.teal),
              title: const Text('Llamar'),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Colors.teal),
              title: const Text('Enviar mensaje'),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.teal),
              title: const Text('Enviar correo'),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value1,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value2,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalSection(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}