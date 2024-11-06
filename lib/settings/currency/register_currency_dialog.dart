import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:tropical_ship_supply/login/build_text_field.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:tropical_ship_supply/main.dart';

void registerCurrency(BuildContext context) {
  TextEditingController currencyNameController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      bool errorMessage = false;
      String errorTxt = '';
      return StatefulBuilder(builder: (context, setState) {
        bool validateFields() {
          if (currencyNameController.text.isEmpty){
            setState(() {
              errorMessage = true;
              errorTxt = 'Por favor, preencha todos os campos obrigatórios';
            });
            return false;
          }
          setState(() {
            errorMessage = false;
          });
          return true;
        }

        return AlertDialog(
          title: const Text('Cadastrar moeda'),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  buildTextField(currencyNameController, 'Moeda', 'Favor, inserir a moeda'),
                  const SizedBox(height: 6),
                  if (errorMessage == true) ...[
                    Text(
                      errorTxt,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    )
                  ],
                  const SizedBox(height: 6)
                ],
              ),
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
                  if (validateFields()) {
                    await ApiService(baseUrl: url_api)
                        .post('moedas', body: {
                      "name": currencyNameController.text,
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
                            description: const Text('Moeda cadastrada com sucesso'),
                            animationType: AnimationType.fromRight,
                            animationDuration: const Duration(milliseconds: 500),
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
