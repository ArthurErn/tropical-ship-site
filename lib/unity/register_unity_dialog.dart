import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:tropical_ship_supply/login/build_text_field.dart';
import 'package:cherry_toast/cherry_toast.dart';

void registerUnity(BuildContext context) {
  bool errorMessage = false;
  String errorTxt = '';
  TextEditingController unityController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Cadastrar unidade'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                buildTextField(unityController, 'Unidade',
                    'Favor, inserir um nome para a unidade'),
                const SizedBox(height: 10),
                if (errorMessage == true) ...[
                  Text(
                    errorTxt,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  )
                ],
                const SizedBox(height: 10)
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
                  await ApiService(baseUrl: 'http://localhost:3000/')
                      .post('unities', body: {
                    "descricao": unityController.text
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
                          title: Text('Sucesso'),
                          description: Text('Unidade cadastrada com sucesso'),
                          animationType: AnimationType.fromRight,
                          animationDuration: const Duration(milliseconds: 500),
                          autoDismiss: true,
                        ).show(context);
                      });
                    }
                  });
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
