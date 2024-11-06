import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/product/model/product_erp.dart';

class ProdutoErpService {
  Future<List<ProdutoErp>> fetchProdutosErp() async {
    final response = await ApiService(baseUrl: 'http://api.zartoo.com.br:9020').getERP('produtosall/3447/TROPICALSYNCPICKING');
    List<dynamic> jsonResponse = response;
    return jsonResponse.map((data) => ProdutoErp.fromJson(data)).toList();
  }
}