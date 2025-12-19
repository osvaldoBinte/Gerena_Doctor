import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientProfileScreen extends StatelessWidget {
  final dynamic appointment;
  final VoidCallback onClose;
  final String? photoUrl; 
  final Map<String, dynamic>? extraData; 

  const PatientProfileScreen({
    Key? key,
    required this.appointment,
    required this.onClose,
    this.photoUrl,
    this.extraData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                child:Column(
  children: [
    // Botón de cerrar en la parte superior
    Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: onClose,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 20,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    ),
    // Información del paciente
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey[300],
            backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                ? NetworkImage(photoUrl!)
                : null,
            child: photoUrl == null || photoUrl!.isEmpty
                ? Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey[600],
                  )
                : null,
          ),
        ],
      ),
    ),
    const SizedBox(height: 20),
    // Resto del contenido...
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
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            'Paciente',
                            appointment.subject ?? 'Sin nombre',
                            'Estado',
                            extraData?['status'] ?? 'Confirmada',
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
                          if (extraData?['doctorName'] != null) ...[
                            const SizedBox(height: 16),
                            _buildSingleInfoRow(
                              'Doctor',
                              extraData!['doctorName'],
                            ),
                          ],
                          if (extraData?['doctorNotes'] != null && 
                              extraData!['doctorNotes'].toString().isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildSingleInfoRow(
                              'Notas del doctor',
                              extraData!['doctorNotes'],
                            ),
                          ],
                          if (extraData?['diagnosis'] != null && 
                              extraData!['diagnosis'].toString().isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildSingleInfoRow(
                              'Diagnóstico',
                              extraData!['diagnosis'],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Divider(height: 1),
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