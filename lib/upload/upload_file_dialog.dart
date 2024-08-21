import 'dart:html' as html;
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:tropical_ship_supply/product/model/product.dart';

void uploadFile(BuildContext context, Function(dynamic) onAddProduct, {bool isProduct = true} ) {
  bool errorMessage = false;
  String errorTxt = '';
  String? fileName;
  html.File? selectedFile;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Upload de arquivo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
                    uploadInput.accept = '.xlsx, .csv';
                    uploadInput.click();
                    uploadInput.onChange.listen((e) {
                      final files = uploadInput.files;
                      if (files != null && files.isNotEmpty) {
                        final reader = html.FileReader();
                        reader.onLoadEnd.listen((e) {
                          setState(() {
                            fileName = files[0].name;
                            selectedFile = files[0];
                          });
                        });
                        reader.readAsArrayBuffer(files[0]);
                      }
                    });
                  },
                  child: Text('Upload de arquivo .xlsx ou .csv'),
                ),
                const SizedBox(height: 10),
                if (fileName != null)
                  Text('Arquivo: $fileName'),
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
                  if (selectedFile != null) {
                    final reader = html.FileReader();
                    reader.onLoadEnd.listen((e) async {
                      final content = reader.result as List<int>;
                      String fileType = fileName!.endsWith('.csv') ? 'csv' : 'xlsx';

                      await ApiService(baseUrl: 'http://localhost:3000/')
                          .postFile(isProduct ?'products/upload':'upload', content, fileType, fileName!)
                          .then((value) {
                            print(value);
                        if (value['statusCode'] != 201) {
                          setState(() {
                            errorMessage = true;
                            errorTxt = value['message'];
                          });
                        } else {
                          if(isProduct){
                            print(value['body']);
                            onAddProduct(value['body']);
                          }
                          setState(() {
                            errorMessage = false;
                            Navigator.pop(context);
                            CherryToast.success(
                              title: Text('Sucesso'),
                              description: Text('Arquivo carregado com sucesso'),
                              animationType: AnimationType.fromRight,
                              animationDuration: const Duration(milliseconds: 500),
                              autoDismiss: true,
                            ).show(context);
                          });
                        }
                      });
                    });
                    reader.readAsArrayBuffer(selectedFile!);
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
