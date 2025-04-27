import 'package:flutter/material.dart';
import 'package:managegym/main_screen/connection/registrarUsuario/registrarUsuarioModel.dart';
import 'package:managegym/shared/admin_colors.dart';
import 'package:managegym/shared/widgets/input_apellidos_widget.dart';
import 'package:managegym/shared/widgets/input_fecha_nacimiento_widget.dart';
import 'package:managegym/shared/widgets/input_nombre_widget.dart';
import 'package:managegym/shared/widgets/input_sexo_widget.dart';
import 'package:managegym/shared/widgets/input_telefono_widget.dart';
import 'package:managegym/db/database_connection.dart';

class ModalEditarCliente extends StatefulWidget {
  final Usuario cliente;

  const ModalEditarCliente({super.key, required this.cliente});

  @override
  State<ModalEditarCliente> createState() => _ModalEditarClienteState();
}

class _ModalEditarClienteState extends State<ModalEditarCliente> {
  final Color colorTextoDark = const Color.fromARGB(255, 255, 255, 255);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _apellidosController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _correoController;
  late final TextEditingController _diaController;
  late final TextEditingController _mesController = TextEditingController();
  late final TextEditingController _anoController = TextEditingController();
  String? _sexoController;

  // Historial de pagos
  List<Map<String, dynamic>> _historialPagos = [];
  bool _cargandoHistorial = false;

  @override
  void initState() {
    super.initState();
    final cliente = widget.cliente;

    String nombreCompleto = cliente.nombre.trim();
    List<String> partes = nombreCompleto.split(' ');

    if (partes.length > 1 && (cliente.apellidos == null || cliente.apellidos.isEmpty)) {
      _nombreController = TextEditingController(text: partes.first);
      _apellidosController = TextEditingController(text: partes.sublist(1).join(' '));
    } else {
      _nombreController = TextEditingController(text: cliente.nombre);
      _apellidosController = TextEditingController(text: cliente.apellidos);
    }
    _telefonoController = TextEditingController(text: cliente.telefono);
    _correoController = TextEditingController(text: cliente.correo.isNotEmpty ? cliente.correo : "12@gmail.com");
    _sexoController = cliente.sexo;

    if (cliente.fechaNacimiento != null) {
      _diaController = TextEditingController(text: cliente.fechaNacimiento!.day.toString());
      _mesController.text = cliente.fechaNacimiento!.month.toString();
      _anoController.text = cliente.fechaNacimiento!.year.toString();
    } else {
      _diaController = TextEditingController(text: "12");
      _mesController.text = "1";
      _anoController.text = "1938";
    }

    _cargarHistorialPagos();
  }

  Future<void> _cargarHistorialPagos() async {
    setState(() {
      _cargandoHistorial = true;
    });
    try {
      final pagos = await UsuarioDB.obtenerHistorialPagosUsuario(
        idUsuario: widget.cliente.id,
        conn: Database.conn,
      );
      setState(() {
        _historialPagos = pagos;
        _cargandoHistorial = false;
      });
    } catch (e) {
      setState(() {
        _cargandoHistorial = false;
      });
      print('Error cargando historial de pagos: $e');
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _diaController.dispose();
    super.dispose();
  }

  String _formateaFecha(dynamic fecha) {
    if (fecha == null) return '';
    if (fecha is DateTime) {
      return "${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}";
    }
    if (fecha is String && fecha.isNotEmpty) {
      try {
        final date = DateTime.parse(fecha);
        return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      } catch (_) {}
    }
    return fecha.toString();
  }

  void editarCliente() {
    if (_formKey.currentState!.validate()) {
      try {
        final dia = int.parse(_diaController.text);
        final mes = int.parse(_mesController.text);
        final ano = int.parse(_anoController.text);
        final fechaNacimiento = DateTime(ano, mes, dia);
        // Aquí iría el código para actualizar el usuario en la base de datos

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente actualizado con éxito')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        print('Error al procesar la fecha: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al procesar la fecha: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AdminColors colores = AdminColors();
    return AlertDialog(
      backgroundColor: colores.colorFondoModal,
      content: SizedBox(
        height: 935,
        width: 1458,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INFORMACION DEL CLIENTE',
                  style: TextStyle(
                      color: colores.colorTexto,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InputNombreWidget(nombreController: _nombreController),
                      const SizedBox(width: 20),
                      InputApellidoWidget(
                          colorTextoDark: colorTextoDark,
                          apellidosController: _apellidosController),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      InputTelefonoWidget(
                          telefonoController: _telefonoController),
                      const SizedBox(width: 20),
                      InputCorreoElectronicoWidget(
                          colorTextoDark: colorTextoDark,
                          correoController: _correoController),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Fecha de nacimiento',
                        style: TextStyle(
                            color: colores.colorTexto,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          style: TextStyle(color: colores.colorTexto),
                          controller: _diaController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Día',
                            labelStyle: TextStyle(color: colores.colorTexto),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Requerido';
                            }
                            final day = int.tryParse(value);
                            if (day == null || day < 1 || day > 31) {
                              return 'Inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                      Text(
                        '-',
                        style: TextStyle(
                          color: colores.colorTexto,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: DropdownButtonFormField<int>(
                          value: int.tryParse(_mesController.text) ?? 1,
                          style: TextStyle(color: colores.colorTexto),
                          dropdownColor: colores.colorFondoModal,
                          decoration: InputDecoration(
                            labelText: 'Mes',
                            labelStyle: TextStyle(color: colores.colorTexto),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                          ),
                          items: [
                            DropdownMenuItem(value: 1, child: Text('Enero', style: TextStyle(color: colores.colorTexto))),
                            DropdownMenuItem(value: 2, child: Text('Febrero', style: TextStyle(color: colores.colorTexto))),
                            DropdownMenuItem(value: 3, child: Text('Marzo', style: TextStyle(color: colores.colorTexto))),
                            DropdownMenuItem(value: 4, child: Text('Abril', style: TextStyle(color: colores.colorTexto))),
                            DropdownMenuItem(value: 5, child: Text('Mayo', style: TextStyle(color: colores.colorTexto))),
                            DropdownMenuItem(value: 6, child: Text('Junio', style: TextStyle(color: colores.colorTexto))),
                            DropdownMenuItem(value: 7, child: Text('Julio', style: TextStyle(color: colores.colorTexto))),
                            DropdownMenuItem(value: 8, child: Text('Agosto', style: TextStyle(color: colores.colorTexto))),
                            DropdownMenuItem(value: 9, child: Text('Septiembre', style: TextStyle(color: colores.colorTexto))),
                            DropdownMenuItem(value: 10, child: Text('Octubre', style: TextStyle(color: colores.colorTexto))),
                            DropdownMenuItem(value: 11, child: Text('Noviembre', style: TextStyle(color: colores.colorTexto))),
                            DropdownMenuItem(value: 12, child: Text('Diciembre', style: TextStyle(color: colores.colorTexto))),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _mesController.text = value.toString();
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null) return 'Requerido';
                            return null;
                          },
                        ),
                      ),
                      Text(
                        '-',
                        style: TextStyle(
                          color: colores.colorTexto,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          style: TextStyle(color: colores.colorTexto),
                          controller: _anoController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Año',
                            labelStyle: TextStyle(color: colores.colorTexto),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Requerido';
                            }
                            final year = int.tryParse(value);
                            if (year == null || year < 1900 || year > DateTime.now().year) {
                              return 'Inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 88),
                      SizedBox(
                        width: 150,
                        child: DropdownButtonFormField<String>(
                          value: _sexoController ?? 'M',
                          style: TextStyle(color: colores.colorTexto),
                          dropdownColor: colores.colorFondoModal,
                          decoration: InputDecoration(
                            labelText: 'Sexo',
                            labelStyle: TextStyle(color: colores.colorTexto),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colores.colorTexto),
                            ),
                          ),
                          items: [
                            DropdownMenuItem(value: 'M', child: Text('Masculino', style: TextStyle(color: colores.colorTexto))),
                            DropdownMenuItem(value: 'F', child: Text('Femenino', style: TextStyle(color: colores.colorTexto))),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _sexoController = value;
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null) return 'Requerido';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Historial de suscripcciones',
                        style: TextStyle(
                            color: colores.colorTexto,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      if (_historialPagos.isNotEmpty)
                        Text(
                          'Fecha de inscripccion: ${_formateaFecha(_historialPagos.last["fechaInicioMembresia"])}',
                          style: TextStyle(
                            color: colores.colorTexto,
                            fontSize: 20,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HeaderTable(colores: colores),
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: _cargandoHistorial
                        ? const Center(child: CircularProgressIndicator())
                        : _historialPagos.isEmpty
                            ? const Center(child: Text('Sin historial', style: TextStyle(color: Colors.white)))
                            : ListView.builder(
                                itemCount: _historialPagos.length,
                                itemBuilder: (context, index) {
                                  final pago = _historialPagos[index];
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          pago['titulo'] ?? 'Sin nombre',
                                          style: TextStyle(color: colores.colorTexto, fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          _formateaFecha(pago['fechaInicioMembresia']),
                                          style: TextStyle(color: colores.colorTexto, fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          _formateaFecha(pago['fechaFinMembresia']),
                                          style: TextStyle(color: colores.colorTexto, fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          pago['estado'] ?? 'Sin estado',
                                          style: TextStyle(color: colores.colorTexto, fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 75, 55),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text(
                              'CANCELAR',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: editarCliente,
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 131, 55),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text(
                              'GUARDAR',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputCorreoElectronicoWidget extends StatelessWidget {
  AdminColors colores = AdminColors();

  InputCorreoElectronicoWidget({
    super.key,
    required this.colorTextoDark,
    required TextEditingController correoController,
  }) : _correoController = correoController;

  final Color colorTextoDark;
  final TextEditingController _correoController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        style: TextStyle(color: colores.colorTexto),
        controller: _correoController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido';
          }
          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(value)) {
            return 'Correo electronico no valido';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Correo electronico',
          labelStyle: TextStyle(color: colores.colorTexto),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colores.colorTexto),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colores.colorTexto),
          ),
        ),
      ),
    );
  }
}

class HeaderTable extends StatelessWidget {
  final AdminColors colores;
  const HeaderTable({super.key, required this.colores});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: colores.colorCabezeraTabla,
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(
            'Suscripción',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: colores.colorTexto,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          )),
          Expanded(
              child: Text(
            'Fecha de inicio de la suscripción',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: colores.colorTexto,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          )),
          Expanded(
              child: Text(
            'Fecha de fin de la suscripción',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: colores.colorTexto,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          )),
          Expanded(
              child: Text(
            'Estatus',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: colores.colorTexto,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          )),
        ],
      ),
    );
  }
}