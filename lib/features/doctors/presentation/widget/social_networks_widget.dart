import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/snackbar_helper.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialNetworksWidget extends StatelessWidget {
  final PrefilDortorController controller = Get.find<PrefilDortorController>();

  final RxMap<String, bool> _editingModes = <String, bool>{
    'linkedin': false,
    'facebook': false,
    'twitter': false,
    'instagram': false,
  }.obs;

  SocialNetworksWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Image.asset(
                  'assets/icons/link.png',
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
            Divider(height: 2, color: GerenaColors.colorinput),
            _socialMediaConnectRow(
              socialIcon: 'assets/linkedin.png',
              name: 'LinkedIn',
              textcontroller: controller.linkedinController,
              socialKey: 'linkedin',
            ),
            Divider(height: 2, color: GerenaColors.colorinput),
            _socialMediaConnectRow(
              socialIcon: 'assets/facebook.png',
              name: 'Facebook',
              textcontroller: controller.facebookController,
              socialKey: 'facebook',
            ),
            Divider(height: 2, color: GerenaColors.colorinput),
            _socialMediaConnectRow(
              socialIcon: 'assets/twitter.png',
              name: 'X',
              textcontroller: controller.twitterController,
              socialKey: 'twitter',
            ),
            Divider(height: 2, color: GerenaColors.colorinput),
            _socialMediaConnectRow(
              socialIcon: 'assets/instagram.png',
              name: 'Instagram',
              textcontroller: controller.instagramController,
              socialKey: 'instagram',
            ),
            Divider(height: 2, color: GerenaColors.colorinput),
          ],
        ),
      ),
    );
  }

  Widget _socialMediaConnectRow({
    required String socialIcon,
    required String name,
    required TextEditingController textcontroller,
    required String socialKey,
  }) {
    return Obx(() {
      final isEditing = _editingModes[socialKey] ?? false;
      final hasValue = textcontroller.text.isNotEmpty;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    hasValue ? Icons.open_in_new : Icons.link_off,
                    color: hasValue ? GerenaColors.primaryColor : Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: hasValue
                      ? () => controller.openSocialMediaProfile(name, textcontroller.text)
                      : null,
                  tooltip: hasValue ? 'Abrir perfil' : 'No conectado',
                ),
                const SizedBox(width: 10),
                Image.asset(
                  socialIcon,
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.rubik(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: GerenaColors.textPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (!isEditing)
                  GerenaColors.widgetButton(
                    onPressed: () {
                      _editingModes[socialKey] = true;
                    },
                    text: hasValue ? 'Editar' : 'Connect $name',
                    backgroundColor: GerenaColors.colorback,
                    textColor: GerenaColors.colorBotonNavbar,
                    borderRadius: 50,
                    showShadow: false,
                  ),
              ],
            ),
            if (isEditing) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GerenaColors.buildLabeledTextField(
                      'Usuario de $name',
                      textcontroller.text,
                      controller: textcontroller,
                      hintText: '@tu-usuario',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: GerenaColors.widgetButton(
                      onPressed: () async {
                        if (textcontroller.text.isEmpty) {
                          showErrorSnackbar('Por favor ingresa tu nombre de usuario');
                          return;
                        }

                        await controller.updateAccountSettings();
                        _editingModes[socialKey] = false;
                      },
                      text: 'GUARDAR',
                      borderRadius: 5,
                      showShadow: false,
                      isLoading: controller.isUpdating.value,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey[600],
                      ),
                      onPressed: controller.isUpdating.value
                          ? null
                          : () {
                              if (hasValue) {
                                textcontroller.text =
                                    controller.getValueForSocial(socialKey) ?? '';
                              } else {
                                textcontroller.clear();
                              }
                              _editingModes[socialKey] = false;
                            },
                      tooltip: 'Cancelar',
                    ),
                  ),
                ],
              ),
            ],
            if (!isEditing && hasValue) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Text(
                  textcontroller.text,
                  style: GoogleFonts.rubik(
                    fontSize: 13,
                    color: GerenaColors.textSecondaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}