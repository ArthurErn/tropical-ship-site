import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:tropical_ship_supply/login/build_text_field.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:tropical_ship_supply/main.dart';
import 'package:tropical_ship_supply/user/model/option.dart';

void registerClient(BuildContext context) async {
  bool errorMessage = false;
  String errorTxt = '';
  TextEditingController clienteController = TextEditingController();
  TextEditingController comissaoController = TextEditingController();
  TextEditingController lucroController = TextEditingController();
  TextEditingController descontoController = TextEditingController();
  TextEditingController markupController = TextEditingController();

  List<Option> options = [];
  try {
    var response =
        await ApiService(baseUrl: url_api).get('profiles');
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
          if (clienteController.text.isEmpty ||
              descontoController.text.isEmpty ||
              comissaoController.text.isEmpty
              || lucroController.text.isEmpty || markupController.text.isEmpty) {
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
                buildTextField(clienteController, 'Cliente',
                    'Favor, inserir um nome de cliente'),
                const SizedBox(height: 10),
                buildTextField(
                    comissaoController, 'Comissão', 'Favor, inserir uma comissão'),
                const SizedBox(height: 10),
                buildTextField(
                    descontoController, 'Desconto', 'Favor, inserir um desconto'),
                    const SizedBox(height: 10),
                buildTextField(
                    lucroController, 'Lucro', 'Favor, inserir o lucro'),
                    const SizedBox(height: 10),
                buildTextField(
                    markupController, 'Markup', 'Favor, inserir o markup'),

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
                    await ApiService(baseUrl: url_api)
                        .post('client', body: {
                          "cliente": clienteController.text,
                          "comissao": comissaoController.text,
                          "lucro": lucroController.text,
                          "desconto": descontoController.text,
                          "markup": markupController.text
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
                                const Text('Cliente cadastrado com sucesso'),
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
