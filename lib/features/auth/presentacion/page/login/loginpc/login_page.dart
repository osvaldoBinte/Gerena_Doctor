import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import 'package:google_fonts/google_fonts.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WindowListener {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GerenaColors.backgroundlogin,
      body: LayoutBuilder(
        builder: (context, constraints) {
          
          return Stack(
            children: [
              
              Center(
                child: SingleChildScrollView(
                  child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
                            GerenaColors.createAppLogo(),
                            const SizedBox(height: 50),
                            
                            Container(
                              width: constraints.maxWidth * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                    obscureText: _obscureText,
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
                                        Get.toNamed(RoutesNames.dashboardSPage);
                                        print('Iniciando sesión...');
                                      },
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 30),
                                  
                                  Center(
                                    child: GerenaColors.createLoginButton(
                                      text: 'Iniciar con código QR',
                                      onPressed: () {
                                        Get.toNamed(RoutesNames.dashboardSPage);
                                        print('Iniciando sesión...');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                ),
              ),
               /*
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: GerenaColors.textLightColor,
                              ),
                              child: Text(
                                'ESP',
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.bold,
                                  color: GerenaColors.textLightColor,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: GerenaColors.textLightColor.withOpacity(0.7),
                              ),
                              child: Text(
                                'ENG',
                                style: GoogleFonts.rubik( 
                                  color: GerenaColors.textLightColor.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                       
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: GerenaColors.textLightColor,
                              ),
                              child: Text(
                                'Contáctanos',
                                style: GoogleFonts.rubik( 
                                  color: GerenaColors.textLightColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: GerenaColors.textLightColor,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min, 
                                children: [
                                  Text(
                                    'Soporte técnico',
                                    style: GoogleFonts.rubik(
                                      color: GerenaColors.textLightColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Image.asset(
                                    'assets/icons/headset_mic.png',
                                    width: 18,
                                    height: 18,
                                    color: GerenaColors.textLightColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                */
            ],
          );
        },
      ),
    );
  }
}