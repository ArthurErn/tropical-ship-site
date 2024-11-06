import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:tropical_ship_supply/home_page/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tropical_ship_supply/main.dart';
import 'package:tropical_ship_supply/vessel/model/vessel.dart';
import 'package:tropical_ship_supply/vessel/vessel_grid_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool errorMessage = false;
  String errorTxt = '';

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }

  void _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false;
      if (_rememberMe) {
        userController.text = prefs.getString('username') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  void _saveUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setBool('remember_me', true);
      await prefs.setString('username', userController.text);
      await prefs.setString('password', passwordController.text);
    } else {
      await prefs.remove('remember_me');
      await prefs.remove('username');
      await prefs.remove('password');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: screenWidth > 1300 ? constraints.maxWidth * 0.38 : constraints.maxWidth * 0.55,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Random Logo
                    Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      child: Image.asset('lib/assets/images/logo.png', height: 200),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: userController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        errorStyle: const TextStyle(color: Colors.red),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: AppColors().blueColor,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Favor, informe seu nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        errorStyle: const TextStyle(color: Colors.red),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 36, 50, 255),
                          ),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Favor, informe sua senha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: const Color.fromARGB(255, 36, 50, 255),
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text('Lembrar login'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await ApiService(baseUrl: url_api).post(
                              'auth/login',
                              body: {
                                "username": userController.text,
                                "password": passwordController.text
                              },
                              headers: <String, String>{'Content-Type': 'application/json'},
                            ).then((value) {
                              if (value['statusCode'] != 201) {
                                setState(() {
                                  errorMessage = true;
                                  errorTxt = value['message'];
                                });
                              } else {
                                _saveUserCredentials(); // Salva as credenciais
                                setState(() {
                                  errorMessage = false;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const VesselPage()),
                                  );
                                });
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(255, 36, 50, 255),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (errorMessage == true)
                      Text(
                        errorTxt,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
