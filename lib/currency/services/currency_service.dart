import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/generic/base_model.dart';
import 'package:tropical_ship_supply/vessel/model/vessel.dart';

class CurrencyService {
  final ApiService apiService;

  CurrencyService({required this.apiService});

  Future<List<BaseModel>> fetchCurrencies() async {
    final response = await apiService.get('moedas');
    List<dynamic> jsonResponse = response;
    return jsonResponse.map((data) => BaseModel.fromJson(data)).toList();
  }
}