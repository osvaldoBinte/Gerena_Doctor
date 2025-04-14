class UsuariosModel {
  final int id;
  final String nombre;
  final String apellidos;
  final String correo;
  final String telefono;
  final String fechaNacimiento;
  final String fechaRegistro;
  final bool registroHuella; // 0 o 1
  final bool sincronizacionNube;

  UsuariosModel(
      {required this.id,
      required this.nombre,
      required this.apellidos,
      required this.correo,
      required this.telefono,
      required this.fechaNacimiento,
      required this.fechaRegistro,
      required this.registroHuella,
      required this.sincronizacionNube});

  factory UsuariosModel.fromMap(Map<String, dynamic> map) {
    return UsuariosModel(
        id: map['id'],
        nombre: map['nombre'],
        apellidos: map['apellidos'],
        correo: map['correo'],
        telefono: map['telefono'],
        fechaNacimiento: map['fechaNacimiento'],
        fechaRegistro: map['fechaRegistro'],
        registroHuella: map['registroHuella'],
        sincronizacionNube: map['sincronizacionNube']);
  }


  
}
