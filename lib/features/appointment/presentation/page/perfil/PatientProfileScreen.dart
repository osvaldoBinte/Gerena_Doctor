import 'package:flutter/material.dart';
import 'package:gerena/features/appointment/domain/entities/getappointment/get_apppointment_entity.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/modal_cancelar_cita.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/modal_completar_cita.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientProfileScreen extends StatelessWidget {
  final GetApppointmentEntity appointmentEntity;
  final VoidCallback onClose;

  const PatientProfileScreen({
    Key? key,
    required this.appointmentEntity,
    required this.onClose,
  }) : super(key: key);

  void _navigateToDoctorProfile() {
    final startController = Get.find<StartController>();
    startController.showDoctorProfilePage(
      doctorData: {
        'userId': appointmentEntity.doctorId,
        'doctorName': appointmentEntity.doctorName,
        'specialty': '',
        'location': '',
        'profileImage': appointmentEntity.foto ?? 'assets/logo/logo.png',
        'rating': 0.0,
        'reviews': '',
        'info': '',
      },
    );
  }

  void _navigateToUserProfile() {
    final startController = Get.find<StartController>();
    startController.showUserProfilePage(
      userData: {
        'userId': appointmentEntity.clientId,
        'userName': appointmentEntity.clientName,
        'username': appointmentEntity.clientName.toLowerCase().replaceAll(' ', ''),
      },
    );
  }

  Future<void> _callPhoneNumber() async {
    final phoneNumber = '+${appointmentEntity.clientPhone}';
    final phoneUri = Uri.parse('tel:$phoneNumber');

    try {
      await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print('❌ Error al intentar llamar: $e');
    }
  }
void _showCompleteAppointmentDialog() {
  ModalCompletarCita.show(appointmentEntity.id);
}

void _showCancelAppointmentDialog() {
  ModalCancelarCita.show(appointmentEntity.id);
}

  @override
  Widget build(BuildContext context) {
    final isCompleted = appointmentEntity.status.toLowerCase() == 'completada';
    final isCancelled = appointmentEntity.status.toLowerCase() == 'cancelada';
    final isPending = appointmentEntity.status.toLowerCase() == 'pendiente' || 
                      appointmentEntity.status.toLowerCase() == 'confirmada';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        onPressed: _callPhoneNumber,
        backgroundColor: Colors.teal[400],
        child: const Icon(
          Icons.phone,
          color: Colors.white,
        ),
      ),
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
                child: Column(
                  children: [
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
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: _navigateToUserProfile,
                                  child: Text(
                                    appointmentEntity.clientName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A5F7A),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${appointmentEntity.clientId}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.teal[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _navigateToUserProfile,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.teal[400]!,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: appointmentEntity.foto != null && appointmentEntity.foto!.isNotEmpty
                                    ? NetworkImage(appointmentEntity.foto!)
                                    : null,
                                child: appointmentEntity.foto == null || appointmentEntity.foto!.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.grey[600],
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
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
                            appointmentEntity.appointmentType,
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
                              appointmentEntity.consultationReason.isNotEmpty
                                  ? appointmentEntity.consultationReason
                                  : 'Sin motivo especificado',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _formatTime(DateTime.parse(appointmentEntity.startDateTime)),
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
                          _buildPatientInfoRow(
                            'Paciente',
                            appointmentEntity.clientName,
                            'Estado',
                            appointmentEntity.status,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            'Fecha',
                            _formatDate(DateTime.parse(appointmentEntity.startDateTime)),
                            'Hora',
                            _formatTime(DateTime.parse(appointmentEntity.startDateTime)),
                          ),
                          const SizedBox(height: 16),
                          _buildSingleInfoRow(
                            'Tipo de cita',
                            appointmentEntity.appointmentType,
                          ),
                          if (appointmentEntity.consultationReason.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildSingleInfoRow(
                              'Motivo de consulta',
                              appointmentEntity.consultationReason,
                            ),
                          ],
                          const SizedBox(height: 16),
                          _buildDoctorInfoRow(
                            'Doctor',
                            appointmentEntity.doctorName,
                          ),
                          if (appointmentEntity.doctorNotes.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildSingleInfoRow(
                              'Notas del doctor',
                              appointmentEntity.doctorNotes,
                            ),
                          ],
                          if (appointmentEntity.diagnosis.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildSingleInfoRow(
                              'Diagnóstico',
                              appointmentEntity.diagnosis,
                            ),
                          ],
                          if (appointmentEntity.cancellationReason.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildSingleInfoRow(
                              'Razón de cancelación',
                              appointmentEntity.cancellationReason,
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // 🔥 SECCIÓN DE BOTONES DE ACCIÓN
                    if (isPending) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _showCompleteAppointmentDialog,
                                icon: const Icon(Icons.check_circle_outline, size: 20),
                                label: const Text(
                                  'Completar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[600],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _showCancelAppointmentDialog,
                                icon: const Icon(Icons.cancel_outlined, size: 20),
                                label: const Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[600],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    // INFORMACIÓN MÉDICA DEL PACIENTE
                    if (_hasMedicalInfo()) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.medical_information,
                                  size: 20,
                                  color: Colors.teal[700],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Historial Médico del Paciente',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            if (appointmentEntity.alergias != null && appointmentEntity.alergias!.isNotEmpty) ...[
                              _buildMedicalInfoCard(
                                'Alergias',
                                appointmentEntity.alergias!,
                                Icons.warning_amber_rounded,
                                Colors.orange,
                              ),
                              const SizedBox(height: 12),
                            ],
                            
                            if (appointmentEntity.padecimientos != null && appointmentEntity.padecimientos!.isNotEmpty) ...[
                              _buildMedicalInfoCard(
                                'Padecimientos',
                                appointmentEntity.padecimientos!,
                                Icons.medical_services,
                                Colors.red,
                              ),
                              const SizedBox(height: 12),
                            ],
                            
                            if (appointmentEntity.enfermedadesCirugias != null && appointmentEntity.enfermedadesCirugias!.isNotEmpty) ...[
                              _buildMedicalInfoCard(
                                'Enfermedades y Cirugías',
                                appointmentEntity.enfermedadesCirugias!,
                                Icons.local_hospital,
                                Colors.purple,
                              ),
                              const SizedBox(height: 12),
                            ],
                            
                            if (appointmentEntity.pruebasEstudios != null && appointmentEntity.pruebasEstudios!.isNotEmpty) ...[
                              _buildMedicalInfoCard(
                                'Pruebas y Estudios',
                                appointmentEntity.pruebasEstudios!,
                                Icons.science,
                                Colors.blue,
                              ),
                              const SizedBox(height: 12),
                            ],
                            
                            if (appointmentEntity.comentarios != null && appointmentEntity.comentarios!.isNotEmpty) ...[
                              _buildMedicalInfoCard(
                                'Comentarios Adicionales',
                                appointmentEntity.comentarios!,
                                Icons.comment,
                                Colors.teal,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    
                    const Divider(height: 1),
                    
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMedicalSection(
                            'ID de Cita',
                            '#${appointmentEntity.id}',
                          ),
                          const SizedBox(height: 16),
                          _buildMedicalSection(
                            'Inicio',
                            _formatFullDateTime(DateTime.parse(appointmentEntity.startDateTime)),
                          ),
                          const SizedBox(height: 16),
                          _buildMedicalSection(
                            'Fin',
                            _formatFullDateTime(DateTime.parse(appointmentEntity.endDateTime)),
                          ),
                          const SizedBox(height: 20),
                          _buildDoctorSection(),
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

  bool _hasMedicalInfo() {
    return (appointmentEntity.alergias != null && appointmentEntity.alergias!.isNotEmpty) ||
        (appointmentEntity.padecimientos != null && appointmentEntity.padecimientos!.isNotEmpty) ||
        (appointmentEntity.enfermedadesCirugias != null && appointmentEntity.enfermedadesCirugias!.isNotEmpty) ||
        (appointmentEntity.pruebasEstudios != null && appointmentEntity.pruebasEstudios!.isNotEmpty) ||
        (appointmentEntity.comentarios != null && appointmentEntity.comentarios!.isNotEmpty);
  }

  Widget _buildMedicalInfoCard(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 22,
              color: color,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _navigateToDoctorProfile,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.teal[400]!,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                backgroundImage: appointmentEntity.foto != null && appointmentEntity.foto!.isNotEmpty
                    ? NetworkImage(appointmentEntity.foto!)
                    : null,
                child: appointmentEntity.foto == null || appointmentEntity.foto!.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey[600],
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Médico asignado',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: _navigateToDoctorProfile,
                  child: Text(
                    appointmentEntity.doctorName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _navigateToDoctorProfile,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.teal[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfoRow(
    String label1,
    String patientName,
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
              GestureDetector(
                onTap: _navigateToUserProfile,
                child: Text(
                  patientName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A5F7A),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
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

  Widget _buildDoctorInfoRow(String label, String doctorName) {
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
        GestureDetector(
          onTap: _navigateToDoctorProfile,
          child: Text(
            doctorName,
            style: TextStyle(
              fontSize: 14,
              color: Colors.teal[700],
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
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