import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/main.dart';
import 'package:tropical_ship_supply/price/widgets/price_product_grid.dart';
import 'package:tropical_ship_supply/price/widgets/price_scroll_behavior.dart';
import 'package:csv/csv.dart';
import 'package:tropical_ship_supply/price/widgets/upload_product_file.dart';
import 'package:tropical_ship_supply/product/model/product.dart';

String dolarPrice = '0.00';

class ProdutoCSV {
  final String item;
  final String cod;
  final String descricaoIngles;
  final String descricaoPrt;
  final String qntPedido;
  final String unit;
  final String endereco;
  final String qntCompras;
  final String checkSeparacao;

  ProdutoCSV({
    required this.item,
    required this.cod,
    required this.descricaoIngles,
    required this.descricaoPrt,
    required this.qntPedido,
    required this.unit,
    this.endereco = '',
    this.qntCompras = '',
    this.checkSeparacao = '',
  });

  List<String> toCSVRow() {
    return [
      item,
      cod,
      descricaoIngles,
      descricaoPrt,
      qntPedido,
      unit,
      endereco,
      qntCompras,
      checkSeparacao,
    ];
  }
}

class PricePage extends StatefulWidget {
  const PricePage({super.key});

  @override
  State<PricePage> createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {
  TextEditingController productController = TextEditingController();
  TextEditingController agentController = TextEditingController();
  TextEditingController vesselController = TextEditingController();
  TextEditingController portController = TextEditingController();
  TextEditingController clientController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController paymentTermsController = TextEditingController();
  List<String> clients = [];
  List<String> products = [];
  List<String> paymentTerms = [];
  List<String> currency = [];
  List<Produto> productList = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    clients = await fetchClientNames();
    products = await fetchProductNames();
    dolarPrice = await fetchDollarPrice();
    currency = await fetchCurrencies();
    paymentTerms = await fetchPaymentTerms();
    setState(() {});
  }

  Future<List<String>> fetchClientNames() async {
    var response =
        await ApiService(baseUrl: url_api).getList('client/clientNames');
    return List<String>.from(
        jsonDecode(response).map((item) => item.toString()));
  }

  Future<List<String>> fetchPaymentTerms() async {
    var response =
        await ApiService(baseUrl: url_api).getList('payment-terms/names');
    return List<String>.from(
        jsonDecode(response).map((item) => item.toString()));
  }

  Future<List<String>> fetchCurrencies() async {
    var response = await ApiService(baseUrl: url_api).getList('moedas/names');
    return List<String>.from(
        jsonDecode(response).map((item) => item.toString()));
  }

  Future<List<String>> fetchProductNames() async {
    var response =
        await ApiService(baseUrl: url_api).getList('products/productNames');
    return List<String>.from(
        jsonDecode(response).map((item) => item.toString()));
  }

  Future<String> fetchDollarPrice() async {
    var response =
        await ApiService(baseUrl: 'https://economia.awesomeapi.com.br')
            .get('/json/daily/USD-BRL/0');
    return response[0]['ask'];
  }

  Future<Map<String, dynamic>?> fetchClientData(String clientName) async {
    var response = await ApiService(baseUrl: url_api).get('client');
    return response.cast<Map<String, dynamic>>().firstWhere(
          (client) => client['cliente'] == clientName,
          orElse: () => null!,
        );
  }

  double calculateProductPrice(
      Produto produto, Map<String, dynamic> clientData) {
    // Valores do cliente
    double comissao = double.tryParse(clientData['comissao'].toString()) ?? 0.0;
    double descontoCliente =
        double.tryParse(clientData['desconto'].toString()) ?? 0.0;
    double lucro = double.tryParse(clientData['lucro'].toString()) ?? 0.0;
    double markup = 1 / (1 - lucro);

    // Usa o custo original em real
    double custoReal = double.tryParse(produto.custo ?? '0.0') ?? 0.0;
    double descontoProduto = double.tryParse(produto.desconto ?? '0.0') ?? 0.0;
    double cambio = double.tryParse(dolarPrice) ?? 1.0;
    // Fórmula para o preço do produto
    return custoReal *
        (1 - descontoProduto) *
        markup /
        (1 - comissao) /
        (1 - descontoCliente) /
        cambio;
  }

  Future<void> updateProductPrices() async {
    // Obtenha os dados do cliente
    String clientName = clientController.text;
    Map<String, dynamic>? clientData = await fetchClientData(clientName);

    if (clientData != null) {
      setState(() {
        for (var produto in productList) {
          double precoProduto = calculateProductPrice(produto, clientData);
          produto.precoCalculado =
              precoProduto.toStringAsFixed(2); // Armazena o preço calculado
        }
      });
    } else {
      print('Cliente não encontrado.');
    }
  }

  void getProductInfo(String name) async {
    var response =
        await ApiService(baseUrl: url_api).get('products/search?term=$name');
    var jsonData = response[0];
    Produto produto = Produto.fromJson(jsonData);
    setState(() {
      productList.add(produto);
    });
  }

  List<String> getSuggestions(String query, String field) {
    List<String> list = [];
    if (field == 'Client') {
      list = clients;
    } else if (field == 'Product') {
      list = products;
    } else if (field == 'Payment Terms') {
      list = paymentTerms;
    } else if (field == 'Currency') {
      list = currency;
    }
    return list
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void addProductsFromApiResponse(Map<String, dynamic> response) {
    List<dynamic> productDescriptions = response['productDescriptions'];

    List<Produto> newProducts = productDescriptions.map((descriptionData) {
      bool hasProductData = descriptionData['check'] == true &&
          descriptionData.containsKey('product');
      if (hasProductData) {
        var productData = descriptionData['product'];
        return Produto(
          id: productData['id'],
          codigo: productData['codigo'],
          fornecedor: productData['fornecedor'] ?? '',
          marca: productData['marca'] ?? '',
          embalagem: productData['embalagem'] ?? '',
          tamanho: productData['tamanho'] ?? '',
          remark: productData['remark'] ?? '',
          descricao: productData['descricao'],
          unity: productData['unity'] ?? '',
          descricaoCompra: productData['descricaoCompra'] ?? '',
          custo: productData['custo'] ?? '',
          departamento: productData['departamento'] ?? '',
          setor: productData['setor'] ?? '',
          codMae: productData['codMae'] ?? '',
          fatorMae: productData['fatorMae'] ?? '',
          endereco: productData['endereco'] ?? '',
          desconto: productData['desconto'],
          recordedAt: productData['recordedAt'],
          originalSheetName: productData['originalSheetName'],
        );
      } else {
        return Produto(
          id: null,
          codigo: null,
          fornecedor: null,
          marca: null,
          embalagem: null,
          tamanho: null,
          remark: null,
          descricao: descriptionData['description'],
          unity: null,
          descricaoCompra: null,
          custo: null,
          departamento: null,
          setor: null,
          codMae: null,
          fatorMae: null,
          endereco: null,
          desconto: null,
          recordedAt: null,
          originalSheetName: null,
        );
      }
    }).toList();

    setState(() {
      updateProductPrices();
      productList.addAll(newProducts);
    });
  }

  void _updateProductList(int index, Produto updatedProduct) {
    setState(() {
      productList[index] = updatedProduct;
      updateProductPrices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: PriceProductGrid(
              products: productList,
              onProductUpdated: _updateProductList,
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors().blueColor,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildAutocomplete(
                    'Pesquisar cliente', 'Client', clientController),
                _buildAutocomplete('Pesquisar termos', 'Payment Terms',
                    paymentTermsController),
                _buildAutocomplete(
                    'Pesquisar moeda', 'Currency', currencyController),
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildTextField(vesselController, 'Vessel'),
                _buildTextField(portController, 'Port'),
                _buildTextField(agentController, 'Agent'),
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildProductSearch(),
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildDollarInfo(),
              ],
            ),
          ],
        ),
      ),
      toolbarHeight: 350,
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return SizedBox(
        width: 350,
        height: 50,
        child: TextFormField(
          controller: controller,
          onFieldSubmitted: (value) => {},
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            hintText: hintText,
          ),
        ));
  }

  Widget _buildAutocomplete(
      String hintText, String field, TextEditingController controller) {
    return SizedBox(
      width: 350,
      child: Autocomplete(
        fieldViewBuilder:
            ((context, textEditingController, focusNode, onFieldSubmitted) =>
                TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onFieldSubmitted: (value) => onFieldSubmitted,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(),
                    hintText: hintText,
                  ),
                )),
        onSelected: (value) {
          setState(() {
            controller.text = value;
          });
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          return getSuggestions(textEditingValue.text, field);
        },
      ),
    );
  }

  Widget _buildProductSearch() {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: 35,
                width: 350,
                color: const Color.fromARGB(255, 216, 203, 88),
                child: const Center(
                  child: Text(
                    'Pesquise em inglês',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                height: 50,
                child: Autocomplete(
                  fieldViewBuilder: ((context, textEditingController, focusNode,
                          onFieldSubmitted) =>
                      TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        onFieldSubmitted: (value) => onFieldSubmitted,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                      )),
                  onSelected: (value) {
                    setState(() {
                      productController.text = value;
                    });
                  },
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return getSuggestions(textEditingValue.text, 'Product');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          if (productController.text.isNotEmpty)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  getProductInfo(productController.text);
                },
                child: const Icon(
                  Icons.add_circle_outline,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
          const SizedBox(width: 8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () =>
                  uploadProductFile(context, addProductsFromApiResponse),
              child: const Icon(
                Icons.file_download,
                size: 35,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDollarInfo() {
    return Row(
      children: [
        Container(
          height: 75,
          width: 90,
          color: const Color.fromARGB(255, 216, 203, 88),
          child: const Center(
            child: Text(
              'PTAX',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Container(
          height: 75,
          width: 150,
          color: Colors.white,
          child: Center(
            child: Text(
              dolarPrice,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
