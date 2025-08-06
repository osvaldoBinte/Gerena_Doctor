import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/page/dashboard/dashboard_controller.dart';
import 'package:gerena/page/dashboard/dashboard_page.dart';
import 'package:gerena/page/store/cartPage/GlobalShopInterface.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileContent extends StatefulWidget {
  const UserProfileContent({Key? key}) : super(key: key);

  @override
  State<UserProfileContent> createState() => _UserProfileContentState();
}

class _UserProfileContentState extends State<UserProfileContent> {
  
  
  @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isSmallScreen = screenWidth < 1200;
  
  return Container(
    color: GerenaColors.backgroundColorfondo,
    child: isSmallScreen 
      ? SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileSection(),
              const SizedBox(height: 20),
              _buildRightSections(),
            ],
          ),
        )
      : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 350, 
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildProfileSection(),
            ),
            
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9, // ← AGREGAR ALTURA
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildRightSections(),
                ),
              ),
            ),
          ],
        ),
  );
}
  
  Widget _buildRightSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAccountSettingsSection(),
        const SizedBox(height: 20),
        _buildAcademicFormationSection(),
        const SizedBox(height: 20),
        _buildConnectedAccountsSection(),
        const SizedBox(height: 20),
        _buildLinksSection(),
        const SizedBox(height: 20),
        _buildPromocionSection(),
      ],
    );
  }
  Widget _buildProfileMenuItem(String title, {String? icon}) {
  return GestureDetector(
    onTap: () {
      _handleMenuNavigation(title);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.rubik(
              fontSize: 14,
              color: GerenaColors.textTertiaryColor,
            ),
          ),
          SizedBox(width: 10),
          if (icon != null) ...[
            Image.asset(
              icon,
              width: 20,
              height: 20,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  size: 20,
                  color: GerenaColors.textSecondaryColor,
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    ),
  );
}
 void _handleMenuNavigation(String menuTitle) {
  switch (menuTitle) {
    case 'Historial de pedidos':
      Get.find<ShopNavigationController>().navigateToHistorialDePedidos();
      Get.to(() => GlobalShopInterface());
      break;
    case 'Membresía':
              try {
              if (!Get.isRegistered<DashboardController>()) {
                Get.put(DashboardController());
              }
              
              final dashboardController = Get.find<DashboardController>();
              dashboardController.showMembresia();
            
              
              print('Navegación exitosa a membresía');
            } catch (e) {
              print('Error en navegación a membresía: $e');
            }
      break;
    case 'Facturación':
      Get.find<ShopNavigationController>().navigateFacturacion();
      Get.to(() => GlobalShopInterface());      print('Navegando a Facturación');
      break;
    case 'Cédula profesional':
      print('Navegando a Cédula profesional');
      break;
    case 'Contáctanos':
      print('Navegando a Contáctanos');
      break;
    case 'Sugerencias':
     try {
              if (!Get.isRegistered<DashboardController>()) {
                Get.put(DashboardController());
              }
              
              final dashboardController = Get.find<DashboardController>();
              dashboardController.showUSugerencia();
            
              
              print('Navegación exitosa a membresía');
            } catch (e) {
              print('Error en navegación a membresía: $e');
            }
      print('Navegando a Sugerencias');
      break;
    case 'Preguntas frecuentes':
     try {
              // Verificar si el controlador ya existe
              if (!Get.isRegistered<DashboardController>()) {
                Get.put(DashboardController());
              }
              
              // Obtener el controlador y mostrar membresía
              final dashboardController = Get.find<DashboardController>();
              dashboardController.showPreguntasFrecuentes();
              
              
              print('Navegación exitosa a membresía');
            } catch (e) {
              print('Error en navegación a membresía: $e');
            }
      print('Navegando a Preguntas frecuentes');
      break;
    default:
      print('Opción no reconocida: $menuTitle');
  }
} 
Widget _buildProfileSection() {
  return Container(
    height: MediaQuery.of(context).size.height * 0.9,
    color: GerenaColors.backgroundColorfondo,
    child: Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Contenido superior en un Expanded con scroll
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: GerenaColors.backgroundColorfondo,
                      boxShadow: [GerenaColors.mediumShadow],
                    ),
                    child: ClipRRect(
                      child: Image.asset(
                        'assets/perfil.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 80,
                            color: GerenaColors.primaryColor,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Resto del contenido...
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: GerenaColors.cardColor,
                      boxShadow: [GerenaColors.mediumShadow]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recompensas:',
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '250 puntos',
                              style: GoogleFonts.rubik(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
            
            // Sección del ejecutivo asignado con botón
          Container(
            width: double.infinity,
  padding: const EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: GerenaColors.cardColor,
    boxShadow: [GerenaColors.mediumShadow]
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Ejecutivo asignado:',
        style: GoogleFonts.rubik(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: GerenaColors.textPrimaryColor,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Carolina Fernández',
        style: GoogleFonts.rubik(
          fontSize: 13,
          color: GerenaColors.textPrimaryColor,
        ),
      ),
      Text(
        'Lun. - Sáb. 9:00 a.m. a 6:00 p.m.',
        style: GoogleFonts.rubik(
          fontSize: 11,
          color:GerenaColors.textPrimaryColor,
        ),
      ),
      const SizedBox(height: 15),
      
      // BOTÓN CON INTRINSIC WIDTH - Tamaño natural
     Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GerenaColors.widgetButton(
            onPressed: () {
              print('Botón contactar presionado');
            },
            text: 'CONTACTAR',
            showShadow: true,
          ),
        ],
      ),
    ],
  ),
),
            
                ],
              ),
            ),
          ),
          
          MouseRegion(
            child: Column(
              children: [
                _buildProfileMenuItem('Historial de pedidos'),
                _buildProfileMenuItem('Membresía'),
                _buildProfileMenuItem('Facturación'),
                _buildProfileMenuItem('Cédula profesional', icon: 'assets/icons/headset_mic.png'),
                _buildProfileMenuItem('Contáctanos'),
                _buildProfileMenuItem('Sugerencias'),
                _buildProfileMenuItem('Preguntas frecuentes'),
                
                GestureDetector(  
                  onTap: () {
                    Get.toNamed(RoutesNames.loginPage);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'Cerrar sesión',
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: GerenaColors.textTertiaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildAccountSettingsSection() {
    return Card(
      elevation: GerenaColors.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: GerenaColors.mediumBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuración de la cuenta',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: GerenaColors.textPrimaryColor,
              ),
            ),
            Text(
              '*Campo obligatorio',
              style: GoogleFonts.rubik(
                fontSize: 12,
                color: GerenaColors.textSecondaryColor,
              ),
            ),
            Text(
              'La información presentada en los siguientes apartados será mostrada según sea llenada en la aplicación para clientes de Gerena.',
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: GerenaColors.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Datos del formulario
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _labeledTextField('Nombre/s*', 'Juan Pedro'),
                      const SizedBox(height: 15),
                      _labeledDropdownField('Profesión*', 'Cirujano estético'),
                      const SizedBox(height: 15),
                      _labeledTextField('Dirección', 'Col. Providencia, Av. Lorem ipsum #3050'),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _labeledTextField('Apellidos*', 'González Pérez'),
                      const SizedBox(height: 15),
                      _labeledTextField('Empresa/Clínica', 'Clínica estética Gerena'),
                      const SizedBox(height: 15),
                      _labeledDropdownField('Ciudad*', 'Guadalajara, Jalisco, México'),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Botón de guardar - ACTUALIZADO
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 120,
                child: GerenaColors.widgetButton(
                  onPressed: () {
                    print('Guardando configuración de cuenta');
                  },
                  text: 'GUARDAR',
                borderRadius: 5,
                showShadow: false, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAcademicFormationSection() {
    return Card(
      elevation: GerenaColors.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: GerenaColors.mediumBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formación académica',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: GerenaColors.textPrimaryColor,
              ),
            ),
            Text(
              'La información presentada en los siguientes apartados será mostrada según sea llenada en la aplicación para clientes de Gerena.',
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: GerenaColors.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 20),
            
            // Campos de formación académica
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _labeledTextField('Título', 'Ej. Rinomodelación'),
                const SizedBox(height: 15),
                _labeledTextField('Disciplina académica', 'Ej. Medicina estética'),
                const SizedBox(height: 15),
                _labeledTextField('Institución', ''),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 120,
                    child: GerenaColors.widgetButton(
                      onPressed: () {
                        print('Guardando formación académica 1');
                      },
                      text: 'GUARDAR',
                     showShadow: false, 
                borderRadius: 5,
                     
                  
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                _labeledTextField('Certificaciones', ''),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 120,
                    child: GerenaColors.widgetButton(
                      onPressed: () {
                        print('Guardando certificaciones');
                      },
                      text: 'GUARDAR',
                  showShadow: false, 
                borderRadius: 5,
                     
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildConnectedAccountsSection() {
    return Card(
      elevation: GerenaColors.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: GerenaColors.mediumBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WEB',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: GerenaColors.textPrimaryColor,
              ),
            ),
            Text(
              'La información presentada en los siguientes apartados será mostrada según sea llenada en la aplicación para clientes de Gerena.',
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: GerenaColors.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Image.asset('assets/icons/link.png',
                width: 20,
                height: 20,
                ),
               
                const SizedBox(width: 8),
                Text(
                  'Cuentas conectadas',
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              'Genera confianza en tu red conectando tus perfiles de redes sociales',
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: GerenaColors.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 15),
            
           _socialMediaConnectRow(
  icon: Icon(
    Icons.menu,
    size: 20,
    color: GerenaColors.textSecondaryColor,
  ),
  socialIcon:  'assets/linkedin.png',
  name: 'LinkedIn',
  isConnected: false,
),
Divider(color: GerenaColors.dividerColor),

_socialMediaConnectRow(
  icon: Icon(
    Icons.menu,
    size: 20,
    color: GerenaColors.textSecondaryColor,
  ),
  socialIcon:  'assets/facebook.png',
  name: 'Facebook',
  isConnected: false,
),
Divider(color: GerenaColors.dividerColor),

_socialMediaConnectRow(
  icon: Icon(
    Icons.menu,
    size: 20,
    color: GerenaColors.textSecondaryColor,
  ),
  socialIcon: 'assets/twitter.png',
  name: 'X',
  isConnected: false,
),
Divider(color: GerenaColors.dividerColor),

_socialMediaConnectRow(
  icon: Icon(
    Icons.menu,
    size: 20,
    color: GerenaColors.textSecondaryColor,
  ),
  socialIcon: 'assets/instagram.png',
  name: 'Instagram',
  isConnected: false,
),
          ],
        ),
      ),
    );
  }
  Widget _buildPromocionSection() {
  return Card(
    elevation: GerenaColors.elevationSmall,
    shape: RoundedRectangleBorder(
      borderRadius: GerenaColors.mediumBorderRadius,
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anuncio/Publicidad',
            style: GoogleFonts.rubik(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          Text(
            'Comparte con tus pacientes las imagenes de tus promociones',
            style: GoogleFonts.rubik(
              fontSize: 14,
              color: GerenaColors.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 20),
          
         Row(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    Expanded(
      flex: 2, 
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Padding para bajar la imagen al nivel del TextField
            Padding(
              padding: const EdgeInsets.only(top: 24), // Ajusta según la altura del label
              child: Image.asset(
                'assets/icons/edit.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _labeledTextField('IMAGEN', ''),
            ),
          ],
        ),
      ),
    ),
    const SizedBox(width: 16),
    Padding(
      padding: const EdgeInsets.only(bottom: 0), 
      child: GerenaColors.widgetButton(
        onPressed: () {
          print('Guardando vínculo');
        },
        text: 'publicar',
        borderRadius: 5,
        showShadow: false, 
      ),
    ),
  ],
),
        ],
      ),
    ),
  );
}
Widget _buildLinksSection() {
  return Card(
    elevation: GerenaColors.elevationSmall,
    shape: RoundedRectangleBorder(
      borderRadius: GerenaColors.mediumBorderRadius,
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vínculos',
            style: GoogleFonts.rubik(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          Text(
            'La información presentada en los siguientes apartados será mostrada según sea llenada en la aplicación para clientes de Gerena.',
            style: GoogleFonts.rubik(
              fontSize: 14,
              color: GerenaColors.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 20),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2, 
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _labeledTextField('Título del vínculo', ''),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _labeledTextField('URL', ''),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 0), 
                child: GerenaColors.widgetButton(
                  onPressed: () {
                    print('Guardando vínculo');
                  },
                  text: 'GUARDAR',
                  borderRadius: 5,
                  showShadow: false, 
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _labeledTextField(String label, String initialValue) {
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
        style: GoogleFonts.rubik(
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintStyle: GoogleFonts.rubik(
            color: GerenaColors.secondaryColor,
            fontSize: 16,
          ),
          filled: true,
          fillColor: GerenaColors.backgroundColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 9,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: GerenaColors.colorinput), // ← AGREGAR BORDE SIEMPRE
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: GerenaColors.colorinput),
          ),
          isDense: true,
        ),
      ),
    ],
  );
}
  
  Widget _labeledDropdownField(String label, String value) {
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
        width: double.infinity, // Asegura que ocupe todo el ancho disponible
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: GerenaColors.smallBorderRadius,
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          isExpanded: true, // ← CLAVE: Hace que el dropdown use todo el ancho
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: InputBorder.none,
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: GerenaColors.primaryColor,
          ),
          onChanged: (String? newValue) {},
          items: <String>[value]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: GoogleFonts.rubik(
                  color: GerenaColors.textPrimaryColor,
                ),
                overflow: TextOverflow.ellipsis, // ← Maneja texto largo
                maxLines: 1, // ← Limita a una línea
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}

  Widget _socialMediaConnectRow({
  required Widget icon,
  required String socialIcon,
  required String name,
  required bool isConnected,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        icon,
        const SizedBox(width: 10),
       Image.asset(
        socialIcon,
        width: 20,
        height: 20,
        fit: BoxFit.cover,
      ),
        const SizedBox(width: 10),
        Text(
          name,
          style: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: GerenaColors.textPrimaryColor,
          ),
        ),
        const Spacer(),
       GerenaColors.widgetButton(
            onPressed: () {
              print('Conectando con $name');
            },
            text: 'Connect $name',
            backgroundColor: GerenaColors.colorback,
            textColor: GerenaColors.colorBotonNavbar,
            borderRadius: 50,
            showShadow: false, 
          ),
      ],
    ),
  );
}
}