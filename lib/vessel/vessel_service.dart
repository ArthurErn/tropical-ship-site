import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/vessel/model/vessel.dart';

class VesselService {
  final ApiService apiService;

  VesselService({required this.apiService});

  Future<List<Vessel>> fetchVessels() async {
    final response = await apiService.get('upload');
    List<dynamic> jsonResponse = response;
    return jsonResponse.map((data) => Vessel.fromJson(data)).toList();
  }
}