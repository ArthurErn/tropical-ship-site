import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:tropical_ship_supply/login/build_text_field.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:tropical_ship_supply/main.dart';
import 'package:tropical_ship_supply/product/model/product.dart';

void registerProduct(BuildContext context, Function(Produto) onAddProduct) {
  TextEditingController codigoController = TextEditingController();
  TextEditingController fornecedorController = TextEditingController();
  TextEditingController marcaController = TextEditingController();
  TextEditingController embalagemController = TextEditingController();
  TextEditingController tamanhoController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController unityController = TextEditingController();
  TextEditingController descricaoCompraController = TextEditingController();
  TextEditingController custoController = TextEditingController();
  TextEditingController departamentoController = TextEditingController();
  TextEditingController setorController = TextEditingController();
  TextEditingController codMaeController = TextEditingController();
  TextEditingController fatorMaeController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  TextEditingController descontoController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      bool errorMessage = false;
      String errorTxt = '';
      return StatefulBuilder(builder: (context, setState) {
        bool validateFields() {
          if (codigoController.text.isEmpty ||
              unityController.text.isEmpty ||
              descricaoCompraController.text.isEmpty ||
              departamentoController.text.isEmpty ||
              setorController.text.isEmpty ||
              codMaeController.text.isEmpty ||
              fatorMaeController.text.isEmpty) {
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
          title: const Text('Cadastrar produto'),
          content: SingleChildScrollView(
            child: Container(
              width: 800,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildTextField(codigoController, 'Código*', 'Favor, inserir o código'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: buildTextField(fornecedorController, 'Fornecedor', 'Favor, inserir o fornecedor'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildTextField(marcaController, 'Marca', 'Favor, inserir a marca'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: buildTextField(embalagemController, 'Embalagem', 'Favor, inserir a embalagem'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildTextField(tamanhoController, 'Tamanho', 'Favor, inserir o tamanho'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: buildTextField(remarkController, 'Remark', 'Favor, inserir o remark'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildTextField(descricaoController, 'Descrição', 'Favor, inserir a descrição'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildTextField(unityController, 'Unidade*', 'Favor, inserir a unidade'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: buildTextField(descricaoCompraController, 'Descrição Compra*', 'Favor, inserir a descrição de compra'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildTextField(custoController, 'Custo', 'Favor, inserir o custo'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: buildTextField(departamentoController, 'Departamento*', 'Favor, inserir o departamento'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildTextField(setorController, 'Setor*', 'Favor, inserir o setor'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: buildTextField(codMaeController, 'Código Mãe*', 'Favor, inserir o código mãe'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: buildTextField(fatorMaeController, 'Fator Mãe*', 'Favor, inserir o fator mãe'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildTextField(enderecoController, 'Endereço', 'Favor, inserir o endereço'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: buildTextField(descontoController, 'Desconto', 'Favor, inserir o desconto'),
                      ),
                    ],
                  ),
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
                        .post('products', body: {
                      "codigo": codigoController.text,
                      "fornecedor": fornecedorController.text,
                      "marca": marcaController.text,
                      "embalagem": embalagemController.text,
                      "tamanho": tamanhoController.text,
                      "remark": remarkController.text,
                      "descricao": descricaoController.text,
                      "unity": unityController.text,
                      "descricaoCompra": descricaoCompraController.text,
                      "custo": custoController.text,
                      "departamento": departamentoController.text,
                      "setor": setorController.text,
                      "codMae": codMaeController.text,
                      "fatorMae": fatorMaeController.text,
                      "endereco": enderecoController.text,
                      "desconto": descontoController.text,
                    }).then((value) {
                      if (value['statusCode'] != 201) {
                        setState(() {
                          errorMessage = true;
                          errorTxt = value['message'];
                        });
                      } else {
                        final novoProduto = Produto(
                          id: value['user']['id'],
                          codigo: codigoController.text,
                          fornecedor: fornecedorController.text,
                          marca: marcaController.text,
                          embalagem: embalagemController.text,
                          tamanho: tamanhoController.text,
                          remark: remarkController.text,
                          descricao: descricaoController.text,
                          unity: unityController.text,
                          descricaoCompra: descricaoCompraController.text,
                          custo: custoController.text,
                          departamento: departamentoController.text,
                          setor: setorController.text,
                          codMae: codMaeController.text,
                          fatorMae: fatorMaeController.text,
                          endereco: enderecoController.text,
                          desconto: descontoController.text,
                        );

                        setState(() {
                          errorMessage = false;
                          Navigator.pop(context);
                          onAddProduct(novoProduto);
                          CherryToast.success(
                            title: const Text('Sucesso'),
                            description: const Text('Produto cadastrado com sucesso'),
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
