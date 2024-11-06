import 'dart:html' as html;
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:tropical_ship_supply/login/build_text_field.dart';
import 'package:tropical_ship_supply/product/model/product.dart';
import 'package:tropical_ship_supply/product/model/product_erp.dart';
import 'package:tropical_ship_supply/product/product_erp_service.dart';

void searchProductDialog(BuildContext context) async{
  TextEditingController codigoController = TextEditingController();
  List<ProdutoErp> data = await ProdutoErpService().fetchProdutosErp();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Pesquisar produto ERP'),
          content: SizedBox(
            height: 170,
            child: Column(
              children: [
                buildTextField(codigoController, 'Código/descrição do produto', ''),
                SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  width: 250,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: ((context, index){
                    return Container(
                      width: 250,
                      child: data[index].prDescricao.toString().contains(codigoController.text) && codigoController.text != ''?Row(
                        children: [
                          Text(data[index].prCodigoExterno, style: TextStyle(fontSize: 10),),
                          SizedBox(width: 10,),
                          Text(data[index].prDescricao, style: TextStyle(fontSize: 10),),
                        ],
                      ):Container(),
                    );
                  })),
                )
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
                  'Pesquisar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState((){});
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
