import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:tropical_ship_supply/login/build_text_field.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:tropical_ship_supply/main.dart';

void registerPaymentTerms(BuildContext context) {
  TextEditingController paymentTermsNameController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      bool errorMessage = false;
      String errorTxt = '';
      return StatefulBuilder(builder: (context, setState) {
        bool validateFields() {
          if (paymentTermsNameController.text.isEmpty){
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
          title: const Text('Cadastrar termo de pagamento'),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  buildTextField(paymentTermsNameController, 'Termos', 'Favor, inserir o nome do termo'),
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
                        .post('payment-terms', body: {
                      "name": paymentTermsNameController.text,
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
                            description: const Text('Termo cadastrado com sucesso'),
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
