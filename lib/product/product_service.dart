import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/product/model/product.dart';

class ProdutoService {
  final ApiService apiService;

  ProdutoService({required this.apiService});

  Future<List<Produto>> fetchProdutos() async {
    final response = await apiService.get('products');
    List<dynamic> jsonResponse = response;
    return jsonResponse.map((data) => Produto.fromJson(data)).toList();
  }
}