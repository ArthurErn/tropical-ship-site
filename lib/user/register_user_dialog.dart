import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:tropical_ship_supply/login/build_text_field.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:tropical_ship_supply/user/model/option.dart';

void registerUser(BuildContext context) async {
  String? selectedOptionId;
  bool errorMessage = false;
  String errorTxt = '';
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController profileController = TextEditingController();

  List<Option> options = [];
  try {
    var response =
        await ApiService(baseUrl: 'http://localhost:3000/').get('profiles');
    List<dynamic> data = response;
    options = data.map((json) => Option.fromJson(json)).toList();
  } catch (e) {
    print(e);
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        void validateFields() {
          if (usernameController.text.isEmpty ||
              emailController.text.isEmpty ||
              passwordController.text.isEmpty ||
              selectedOptionId == null) {
            setState(() {
              errorMessage = true;
              errorTxt = 'Por favor, preencha todos os campos.';
            });
          } else {
            errorMessage = false;
          }
        }

        return AlertDialog(
          title: const Text('Cadastrar usuário'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                buildTextField(usernameController, 'Usuário',
                    'Favor, inserir um nome de usuário'),
                const SizedBox(height: 10),
                buildTextField(
                    emailController, 'E-mail', 'Favor, inserir um email'),
                const SizedBox(height: 10),
                buildTextField(
                    passwordController, 'Senha', 'Favor, inserir uma senha',
                    obscure: true),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: Center(
                    child: InputDecorator(
                      decoration: InputDecoration(
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
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedOptionId,
                          hint: const Text('Selecione um perfil'),
                          items: options.map((Option option) {
                            return DropdownMenuItem<String>(
                              value: option.id,
                              child: Text(option.name),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedOptionId = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (errorMessage == true) ...[
                  Text(
                    errorTxt,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  )
                ],
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              height: 30,
              width: 95,
              decoration: BoxDecoration(
                  color: AppColors().blueColor,
                  borderRadius: BorderRadius.circular(12)),
              child: TextButton(
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  setState(() {
                    validateFields();
                  });
                  if (!errorMessage) {
                    await ApiService(baseUrl: 'http://localhost:3000/')
                        .post('users', body: {
                      "username": usernameController.text,
                      "email": emailController.text,
                      "password": passwordController.text,
                      "profileId": selectedOptionId.toString()
                    }).then((value) {
                      if (value['statusCode'] != 201) {
                        setState(() {
                          errorMessage = true;
                          errorTxt = value['message'];
                        });
                      } else {
                        setState(() {
                          errorMessage = false;
                          Navigator.pop(context);
                          CherryToast.success(
                            title: const Text('Sucesso'),
                            description:
                                const Text('Usuário cadastrado com sucesso'),
                            animationType: AnimationType.fromRight,
                            animationDuration:
                                const Duration(milliseconds: 500),
                            autoDismiss: true,
                          ).show(context);
                        });
                      }
                    });
                  }
                },
              ),
            ),
            TextButton(
              child: Text('Fechar',
                  style: TextStyle(color: AppColors().blueColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    },
  );
}
