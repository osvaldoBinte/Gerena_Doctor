import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:get/get.dart';

class LoginPageMovil extends StatefulWidget {
  const LoginPageMovil({Key? key}) : super(key: key);

  @override
  State<LoginPageMovil> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPageMovil> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundlogin,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GerenaColors.createAppLogo(),
              
              GerenaColors.createLoginLabel('Correo electrónico'),
              
              const SizedBox(height: 8),
              
              GerenaColors.createLoginTextField(
                controller: _emailController,
                hintText: 'username@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),
              
              GerenaColors.createLoginLabel('Contraseña'),
              
              const SizedBox(height: 8),
              
              GerenaColors.createLoginTextField(
                controller: _passwordController,
                hintText: '',
                obscureText: _obscurePassword,
                
              ),
              
              Align(
                alignment: Alignment.centerRight,
                child: GerenaColors.createLoginTextButton(
                  text: 'Olvidé mi contraseña',
                  onPressed: () {
                    print('Recuperar contraseña');
                  },
                  fontSize: 14,
                ),
              ),
              
              const SizedBox(height: 24),
              
              Center(
                child: GerenaColors.createLoginButton(
                  text: 'Iniciar sesión',
                  onPressed: () {
                  Get.offNamed(RoutesNames.homePage);

                    print('Iniciando sesión...');
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              GerenaColors.createLoginButton(
                text: 'Ingresar con Face ID / Huella',
                onPressed: () {
                  print('Login biométrico');
                },
                icon: Image.asset(
                  'assets/icons/fingerprint.png',
                  width: 18,
                  height: 18,
                ),
                width: double.infinity,
              ),
              
              const SizedBox(height: 5),
              
              Center(
                child: GerenaColors.createLoginTextButton(
                  text: 'Registrarse',
                  onPressed: () {
                    print('Ir a registro');
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GerenaColors.createLoginTextButton(
                    text: 'ESP',
                    onPressed: () {
                      print('Idioma: Español');
                    },
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  GerenaColors.createLoginTextButton(
                    text: 'ENG',
                    onPressed: () {
                      print('Idioma: Inglés');
                    },
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  IconButton(
                    onPressed: () {
                      print('Mostrar ayuda');
                    },
                    icon: Image.asset(
                      'assets/icons/headset_mic.png',
                      color: GerenaColors.textLightColor,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}